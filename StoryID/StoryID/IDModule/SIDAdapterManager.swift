//
//  IDAdapterManager.swift
//  idModule
//
//  Created by Sergey Ryazanov on 02.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

import Alamofire
import p2_OAuth2

public final class SIDAdapterManager {

    private static let AdapterTokenKey = "SIDAdapterManager.AdapterToken.Key"
    private static let AdapterAuthKey = "SIDAdapterManager.AdapterAuth.Key"

    public typealias AuthFlowBlock = (OAuth2?, OAuth2JSON?, Error?) -> Void
    public typealias PrepareSettingBlock = ([String: Any]) -> [String: Any]

    public enum ConfigError: Error {
        case incorrectConfigModel
        case dataIsMissing
        case requestError(Error)
    }

    private(set) var configURL: URL
    private(set) var config: SIDConfigModel?

    public init(configURL: URL) {
        self.configURL = configURL
    }

    // MARK: - APIs

    public func requestConfig(completion: ((Result<SIDConfigModel>) -> Void)?) {

        let task = URLSession.shared.dataTask(with: configURL) { [weak self] data, _, error in
            if let error = error {
                completion?(Result.failure(ConfigError.requestError(error)))
            } else if let data = data {
                if let config = try? JSONDecoder().decode(SIDConfigModel.self, from: data) {
                    self?.config = config
                    completion?(Result.success(config))
                } else {
                    completion?(Result.failure(ConfigError.incorrectConfigModel))
                }
            } else {
                completion?(Result.failure(ConfigError.dataIsMissing))
            }
        }

        task.resume()
    }

    // MARK: * Service Flow

    public func serviceFlow(with flowModel: SIDServiceFlowModel, settingBlock: PrepareSettingBlock? = nil, completion: @escaping AuthFlowBlock) {
        var settings = flowModel.settings()

        if let settingBlock = settingBlock {
            settings = settingBlock(settings) as OAuth2JSON
        }

        let oauth2 = OAuth2ClientCredentials(settings: settings)

        self.saveAdapterKey(oauth2)

        oauth2.forgetTokens()
        oauth2.authorize { json, error in
            completion(oauth2, json, error)
        }
    }

    // MARK: * Password Flow

    public func passwordFlow(with flowModel: SIDPasswordFlowModel, settingBlock: PrepareSettingBlock? = nil, completion: @escaping AuthFlowBlock) {
        var settings = flowModel.settings()

        if let settingBlock = settingBlock {
            settings = settingBlock(settings) as OAuth2JSON
        }

        let oauth2 = OAuth2PasswordGrant(settings: settings)

        self.saveAdapterKey(oauth2)

        oauth2.forgetTokens()
        oauth2.authorize { json, error in
            completion(oauth2, json, error)
        }
    }

    // MARK: * Passwordless Flow

    public func reqestPasswordlesCode(with flowModel: SIDPasswordlessFlowModel, completion: @escaping (Result<SIDPasswordlessSignature>) -> Void) {

        func makeRequest(config: SIDConfigModel) {
            guard let endpoint = URL(string: config.issuer)?.appendingPathComponent(flowModel.appendingPath) else {
                let error = NSError(domain: "IDAdapterManager", code: -20, userInfo: [NSLocalizedDescriptionKey: "Невалидное поле issuer в ConfigModel"])
                completion(Result.failure(error))
                return
            }

            var parameters: [String: String] = [:]
            parameters["login"] = flowModel.login
            parameters["client"] = flowModel.clientId
            parameters["secret"] = flowModel.clientSecret

            let headers: HTTPHeaders = ["Content-Type": "application/json"]

            Alamofire.SessionManager.default.request(endpoint, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseData { response in
                    if let error = response.error {
                        completion(Result.failure(error))
                    } else if let data = response.data {
                        do {
                            let signature = try JSONDecoder().decode(SIDPasswordlessSignature.self, from: data)
                            completion(Result.success(signature))
                        } catch {
                            completion(Result.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "IDAdapterManager", code: -10, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ"])
                        completion(Result.failure(error))
                    }
                }
        }

        self.requestConfig { result in
            if case let Result.success(configModel) = result {
                makeRequest(config: configModel)
            } else {
                let error = NSError(domain: "IDAdapterManager", code: -20, userInfo: [NSLocalizedDescriptionKey: "ConfigModel не найден"])
                completion(Result.failure(error))
            }
        }
    }

    public func passwordlessFlow(with flowModel: SIDPasswordlessFlowModel,
                                 code: String,
                                 signature: SIDPasswordlessSignature,
                                 settingBlock: PrepareSettingBlock? = nil,
                                 completion: @escaping AuthFlowBlock) {

        var settings = flowModel.settings()
        settings["code"] = code
        settings["signature"] = signature

        if let settingBlock = settingBlock {
            settings = settingBlock(settings) as OAuth2JSON
        }

        let oauth2 = OAuth2PasswordlessGrant(settings: settings)

        self.saveAdapterKey(oauth2)

        oauth2.forgetTokens()
        oauth2.authorize { json, error in
            completion(oauth2, json, error)
        }
    }
}

// MARK: - Storage

extension SIDAdapterManager {

    public func restoreOldAdapter(client: String, secret: String, isAllowExpired: Bool, completion: @escaping ((Result<OAuth2>) -> Void)) {
        let oldAdapter = self.restoreAdapter()

        self.requestConfig { result in
            switch result {
            case let Result.success(config):
                let newAdapter = OAuth2(settings: self.defaultSettings(for: config, client: client, secret: secret))
                let oauth2 = self.compareAdapters(newAdapter: newAdapter, oldAdapter: oldAdapter)
                self.checkAuthTokenAndComplete(adapter: oauth2, isAllowExpired: isAllowExpired, completion: completion)
            case let Result.failure(error):
                if let oldAdapter = oldAdapter {
                    self.checkAuthTokenAndComplete(adapter: oldAdapter, isAllowExpired: isAllowExpired, completion: completion)
                } else {
                    completion(Result.failure(error))
                }
            }
        }
    }

    private func compareAdapters(newAdapter: OAuth2, oldAdapter: OAuth2?) -> OAuth2 {
        guard let oldAdapter = oldAdapter else { return newAdapter }
        if oldAdapter.authURL == newAdapter.authURL {
            oldAdapter.clientSecret = newAdapter.clientSecret
            oldAdapter.clientId = newAdapter.clientId
            return oldAdapter
        } else {
            return newAdapter
        }
    }

    private func checkAuthTokenAndComplete(adapter: OAuth2, isAllowExpired: Bool, completion: @escaping ((Result<OAuth2>) -> Void)) {

        func finish(adapter: OAuth2?) {
            DispatchQueue.main.async {
                if let adapter = adapter {
                    completion(Result.success(adapter))
                } else {
                    let error = NSError(domain: "IDAdapterManager", code: -16, userInfo: [NSLocalizedDescriptionKey: "Ошибка обновления accessToken по refreshToken"])
                    completion(Result.failure(error))
                }
            }
        }

        guard isAllowExpired == false else {
            finish(adapter: adapter)
            return
        }

        if adapter.refreshToken != nil, adapter.accessToken == nil {
            adapter.doRefreshToken { _, error in
                finish(adapter: error == nil ? adapter : nil)
            }
        } else {
            finish(adapter: adapter)
        }
    }

    // MARK: * Adapter Auth

    private func restoreAdapter() -> OAuth2? {
        let authUrl = UserDefaults.standard.value(forKey: SIDAdapterManager.AdapterAuthKey)
        let tokenUrl = UserDefaults.standard.value(forKey: SIDAdapterManager.AdapterTokenKey)
        guard authUrl != nil || tokenUrl != nil else { return nil }

        var settings: OAuth2JSON = [
            "secret_in_body": true,
        ]

        if let authUrl = authUrl {
            settings["authorize_uri"] = authUrl
        }

        if let tokenUrl = tokenUrl {
            settings["token_uri"] = tokenUrl
        }

        return OAuth2(settings: settings)
    }

    public func saveAdapterKey(_ adapter: OAuth2?) {
        if let adapter = adapter {
            if let tokenUrl = adapter.tokenURL?.absoluteString {
                UserDefaults.standard.set(tokenUrl, forKey: SIDAdapterManager.AdapterTokenKey)
            } else {
                let authUrl = adapter.authURL.absoluteString
                UserDefaults.standard.set(authUrl, forKey: SIDAdapterManager.AdapterAuthKey)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: SIDAdapterManager.AdapterAuthKey)
        }
    }
}

// MARK: - Helpers

fileprivate extension SIDAdapterManager {

    func defaultSettings(for config: SIDConfigModel, client: String, secret: String) -> OAuth2JSON {
        let settings: OAuth2JSON = [
            "authorize_uri": config.authorization_endpoint,
            "token_uri": config.token_endpoint,
            "secret_in_body": true,

            "client_id": client,
            "client_secret": secret,
        ]
        return settings
    }
}
