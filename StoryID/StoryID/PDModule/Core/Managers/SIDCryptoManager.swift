//
//  SIDCryptoManager.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import CryptoSwift

final class SIDCryptoManager {

    public static let instance = SIDCryptoManager()

    private init() {}

    // MARK: - Main

    private var password: [UInt8]? {
        guard let cryptoPassword = SIDSettings.instance.cryptSettings.password?.utf8 else { return nil }
        return Array(cryptoPassword)
    }

    private var salt: [UInt8]? {
        guard let cryptoSalt = SIDSettings.instance.cryptSettings.salt?.utf8 else { return nil }
        return Array(cryptoSalt)
    }

    var key: [UInt8]? {
        guard let password = self.password, let salt = self.salt else { return nil }
        return try? HKDF(password: password, salt: salt, variant: .sha256).calculate()
    }

    // MARK: - Data

    func encrypt<T: Codable>(_ entity: T) -> Data {
        do {
            let encoded = (entity as? Data)?.bytes ?? (try? JSONEncoder().encode(entity).bytes)
            if let encoded = encoded, let key = self.key, let salt = self.salt {
                let encrypted = try ChaCha20(key: key, iv: salt).encrypt(encoded)
                return Data(encrypted)
            }
            return Data()
        } catch {
            print("Unable to encode object: \(error)")
            return Data()
        }
    }

    func decrypt<T>(data: Data) -> T? where T: Codable {
        guard
            let key = self.key,
            let salt = self.salt,
            let decrypted = try? ChaCha20(key: key, iv: salt).decrypt(data.bytes),
            let decoded = (Data(decrypted) as? T) ?? (try? JSONDecoder().decode(T.self, from: Data(decrypted)))
        else { return nil }
        return decoded
    }
}
