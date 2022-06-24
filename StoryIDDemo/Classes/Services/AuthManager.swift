//
//  AuthManager.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID
import p2_OAuth2

final class AuthManager {

    static let instance = AuthManager()

    private var adapterManager: SIDAdapterManager

    private(set) var interceptor: SIDInterceptor?

    private(set) var adapter: OAuth2? {
        didSet {
            self.updateRetrier()
        }
    }

    // MARK: -

    private init() {
        let urlString = AppPropertiesManager.instance.apiConfigUrl
        precondition(urlString != nil, "Config url is missing in AppPropertiesManager")

        self.adapterManager = SIDAdapterManager(configURL: URL(string: urlString!)!)
    }

    // MARK: - APIs

    func verifyCode(phone: String, completion: @escaping ((SIDPasswordlessSignature?, Error?) -> Void)) {
        self.getAdapter(isAllowExpired: true) { [weak self] adapter, error in
            guard let adapter = adapter else {
                let error = NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить адаптер OAuth2"])
                completion(nil, error)
                return
            }

            self?.adapterManager.reqestPasswordlesCode(with: SIDPasswordlessFlowModel(adapter: adapter, login: phone), completion: { result in
                switch result {
                case let .success(signature):
                    completion(signature, nil)
                case let .failure(error):
                    completion(nil, error)
                }
            })
        }
    }

    func login(signature: SIDPasswordlessSignature?, phone: String, code: String, completion: @escaping ((Error?) -> Void)) {
        guard let sign = signature, let expDate = sign.expirationDate, expDate > Date() else {
            let error = NSError(domain: "AuthManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Сигнатура истекла"])
            completion(error)
            return
        }

        self.getAdapter(isAllowExpired: true) { [weak self] adapter, error in
            guard let adapter = adapter else {
                let error = NSError(domain: "AuthManager", code: -3,
                                    userInfo: [NSLocalizedDescriptionKey: "Не удалось получить адаптер: \(error?.localizedDescription ?? "")"])
                completion(error)
                return
            }

            let flowModel = SIDPasswordlessFlowModel(adapter: adapter, login: phone)
            self?.adapterManager.passwordlessFlow(with: flowModel, code: code, signature: sign, completion: { [weak self] adapter, _, error in
                if let error = error {
                    completion(error)
                } else if let adapter = adapter {
                    adapter.storeClientToKeychain()
                    adapter.storeTokensToKeychain()
                    self?.adapter = adapter
                    completion(nil)
                }
            })
        }
    }

    var adapterLock = NSLock()
    public func getAdapter(isAllowExpired: Bool, completion: @escaping ((OAuth2?, Error?) -> Void)) {

        func finish(adapter: OAuth2?, error: Error?) {
            DispatchQueue.main.async {
                completion(adapter, error)
            }
        }

        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        queue.async {
            self.adapterLock.lock()

            if let adapter = self.adapter {
                self.adapterLock.unlock()
                finish(adapter: adapter, error: nil)
            } else {
                let client = AppPropertiesManager.instance.client!
                let secret = AppPropertiesManager.instance.secret!
                self.adapterManager.restoreOldAdapter(client: client, secret: secret, isAllowExpired: isAllowExpired) { result in
                    switch result {
                    case let .success(adapter):
                        queue.async {
                            self.adapterLock.unlock()
                            self.adapter = adapter
                            finish(adapter: adapter, error: nil)
                        }
                    case let .failure(error):
                        queue.async {
                            self.adapterLock.unlock()
                            finish(adapter: nil, error: error)
                        }
                    }
                }
            }
        }
    }

    var isLogined: Bool {
        self.adapter?.clientConfig.accessToken != nil
    }

    // MARK: - Retrier

    func updateRetrier() {
        guard let adapter = self.adapter else {
            self.interceptor = nil
            AlamofireRetrier.interceptor = nil
            SwaggerClientAPI.basePath = "/"
            return
        }

        self.interceptor = SIDInterceptor(oauth2: adapter) { json in
            print("OAuth success")
        } onRefreshError: { error in
            guard let viewController = UIViewController.topVC() else {
                assertionFailure("Can't find topmost view controller")
                return
            }
            AppRouter.instance.showEnterPhone(from: viewController, reason: error.localizedDescription)
        }

        AlamofireRetrier.interceptor = self.interceptor
        SwaggerClientAPI.basePath = self.adapterManager.config?.issuer ?? "/"
    }
}
