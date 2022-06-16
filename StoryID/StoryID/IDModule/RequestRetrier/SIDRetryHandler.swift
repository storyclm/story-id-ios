//
//  SIDRetryHandler.swift
//  iPharmocist ASNA
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 Platfomni. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire

public class SIDRetryHandler: RequestRetrier, RequestAdapter {

    public typealias RefreshSuccessBlock = ((OAuth2JSON) -> Void)
    public typealias RefreshErrorBlock = ((OAuth2Error) -> Void)

    let loader: OAuth2DataLoader

    var onRefreshSuccess: RefreshSuccessBlock?
    var onRefreshError: RefreshErrorBlock?

    public init(oauth2: OAuth2,
                onRefreshSuccess: RefreshSuccessBlock?,
                onRefreshError: RefreshErrorBlock?)
    {
        loader = OAuth2DataLoader(oauth2: oauth2)
        self.onRefreshSuccess = onRefreshSuccess
        self.onRefreshError = onRefreshError
    }

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize { authParams, error in
                guard error?.asOAuth2Error != .alreadyAuthorizing else {
                    // Don't dequeue requests if we are waiting for other authorization request
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.onRefreshError?(error)
                    } else if let authParams = authParams {
                        self?.onRefreshSuccess?(authParams)
                    }
                }

                self.loader.dequeueAndApply { req in
                    var shouldRetry = false
                    if error == nil {
                        shouldRetry = nil != authParams
                    }

                    if let comp = req.context as? RequestRetryCompletion {
                        comp(shouldRetry, 0.0)
                    }
                }
            }
        } else {
            completion(false, 0.0) // not a 401, not our problem
        }
    }

    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard nil != loader.oauth2.accessToken else {
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2)
    }
}
