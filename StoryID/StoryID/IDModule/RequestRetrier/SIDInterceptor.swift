//
//  SIDInterceptor.swift
//  iPharmocist ASNA
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 Platfomni. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire

public class SIDInterceptor: RequestInterceptor {

    public typealias RefreshSuccessBlock = ((OAuth2JSON) -> Void)
    public typealias RefreshErrorBlock = ((OAuth2Error) -> Void)

    let loader: OAuth2DataLoader

    var onRefreshSuccess: RefreshSuccessBlock?
    var onRefreshError: RefreshErrorBlock?

    public init(oauth2: OAuth2,
                onRefreshSuccess: RefreshSuccessBlock?,
                onRefreshError: RefreshErrorBlock?)
    {
        self.loader = OAuth2DataLoader(oauth2: oauth2)
        self.onRefreshSuccess = onRefreshSuccess
        self.onRefreshError = onRefreshError
    }

    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
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

                    if let comp = req.context as? ((RetryResult) -> Void) {
                        if shouldRetry {
                            comp(.retry)
                        } else {
                            comp(.doNotRetry)
                        }
                    }
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        if self.loader.oauth2.accessToken != nil {
            do {
                let newRequest = try urlRequest.signed(with: self.loader.oauth2)
                completion(.success(newRequest))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.success(urlRequest))
        }
    }
}
