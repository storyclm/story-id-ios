//
//  SIDSettings.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

public final class SIDSettings {

    public static let instance = SIDSettings()

    private init() {}

    // MARK: -

    public var userId: String?

    public var isRemoveImageAtSync: Bool = false

    public var cryptoPassword: String?
    public var cryptoSalt: String?

    // MARK: - Private

    var isCryptoEnabled: Bool {
        return self.cryptoPassword?.isEmpty == false && self.cryptoSalt?.isEmpty == false
    }
}
