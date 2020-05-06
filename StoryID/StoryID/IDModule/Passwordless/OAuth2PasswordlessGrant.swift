//
//  OAuth2PasswordlessGrant.swift
//  idModule
//
//  Created by Sergey Ryazanov on 06.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation
import p2_OAuth2

open class OAuth2PasswordlessGrant: OAuth2 {

    open override class var grantType: String {
        return "passwordless"
    }

    open override class var clientIdMandatory: Bool {
        return true
    }

    open var login: String?
    open var code: String?
    open var signature: SIDPasswordlessSignature?

    public override init(settings: OAuth2JSON) {
        self.login = settings["login"] as? String
        self.code = settings["code"] as? String
        self.signature = settings["signature"] as? SIDPasswordlessSignature
        super.init(settings: settings)
    }

    // MARK: - Auth Flow

    open override func doAuthorize(params inParams: OAuth2StringDict? = nil) throws {
        self.obtainAccessToken(params: inParams) { params, error in
            if let error = error {
                self.didFail(with: error.asOAuth2Error)
            } else {
                self.didAuthorize(withParameters: params ?? OAuth2JSON())
            }
        }
    }

    public func obtainAccessToken(params: OAuth2StringDict? = nil, callback: @escaping ((_ params: OAuth2JSON?, _ error: OAuth2Error?) -> Void)) {
        do {
            let post = try accessTokenRequest(params: params).asURLRequest(for: self)
            logger?.debug("OAuth2", msg: "Requesting new access token from \(post.url?.description ?? "nil")")

            perform(request: post) { response in
                do {
                    let data = try response.responseData()
                    let params = try self.parseAccessTokenResponse(data: data)
                    self.logger?.debug("OAuth2", msg: "Did get access token [\(nil != self.clientConfig.accessToken)]")
                    callback(params, nil)
                } catch {
                    callback(nil, error.asOAuth2Error)
                }
            }
        } catch {
            callback(nil, error.asOAuth2Error)
        }
    }

    open func accessTokenRequest(params: OAuth2StringDict? = nil) throws -> OAuth2AuthRequest {
        guard let clientId = clientConfig.clientId, !clientId.isEmpty else {
            throw OAuth2Error.noClientId
        }
        guard nil != clientConfig.clientSecret else {
            throw OAuth2Error.noClientSecret
        }

        let req = OAuth2AuthRequest(url: clientConfig.tokenURL ?? clientConfig.authorizeURL)
        req.params["grant_type"] = type(of: self).grantType
        req.params["login"] = self.login
        req.params["code"] = self.code
        req.params["expiration"] = self.signature?.expiration
        req.params["signature"] = self.signature?.signature
        if let scope = clientConfig.scope {
            req.params["scope"] = scope
        }
        req.add(params: params)

        return req
    }
}
