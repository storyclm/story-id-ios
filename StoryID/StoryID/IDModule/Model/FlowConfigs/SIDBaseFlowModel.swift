//
//  SIDBaseFlowModel.swift
//  idModule
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import p2_OAuth2

open class SIDBaseFlowModel {

    enum InitType {
        case adapter(OAuth2)
        case urls(String, String, String, String?)
    }

    private let initType: InitType

    public init(clientId: String, clientSecret: String, authorizeURL: String, tokenURL: String?) {
        self.initType = InitType.urls(clientId, clientSecret, authorizeURL, tokenURL)
    }

    public init(adapter: OAuth2) {
        self.initType = InitType.adapter(adapter)
    }

    public func settings() -> OAuth2JSON {
        var settings: OAuth2JSON = [
            "authorize_uri": self.authURL, // self.adapter.clientConfig.authorizeURL.absoluteString,
            "secret_in_body": true,
        ]

        if let client = self.clientId {
            settings["client_id"] = client
        }

        if let secret = self.clientSecret {
            settings["client_secret"] = secret
        }

        if let tokenURL = self.tokenURL {
            settings["token_uri"] = tokenURL
        }

        return settings
    }

    // MARK: - Additional

    var clientId: String? {
        switch self.initType {
        case let .adapter(adapter): return adapter.clientConfig.clientId
        case let .urls(client, _, _, _): return client
        }
    }

    var clientSecret: String? {
        switch self.initType {
        case let .adapter(adapter): return adapter.clientConfig.clientSecret
        case let .urls(_, secret, _, _): return secret
        }
    }

    var tokenURL: String? {
        switch self.initType {
        case let .adapter(adapter): return adapter.tokenURL?.absoluteString
        case let .urls(_, _, _, tokenURL): return tokenURL
        }
    }

    var authURL: String {
        switch self.initType {
        case let .adapter(adapter): return adapter.authURL.absoluteString
        case let .urls(_, _, authURL, _): return authURL
        }
    }
}
