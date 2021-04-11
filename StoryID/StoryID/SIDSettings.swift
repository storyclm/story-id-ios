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

    public let cryptSettings = SIDCryptSettings()
}

public final class SIDCryptSettings {

    public var password: String?
    public var salt: String?

    public var isCryptImages: Bool = false
    public var isCryptDBValues: Bool = false

    // MARK: - Private

    internal var isCryptAvailable: Bool {
        return self.password?.isEmpty == false && self.salt?.isEmpty == false
    }

    internal var isImageCryptEnabled: Bool {
        return isCryptAvailable && isCryptImages
    }

    internal var isDBValuesCryptEnabled: Bool {
        return isCryptAvailable && isCryptDBValues
    }
}
