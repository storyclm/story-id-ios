//
//  SIDProfileService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public class SIDProfileService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        completion(nil)
    }

    // MARK: - Public

    public func profile() -> IDContentProfile? {
        return IDContentProfile.firstModel()
    }

    public func setProfile(email: String?, emailVerified: Bool = false, phone: String?, phoneVerified: Bool = false, username: String?) {
        let profileModel = self.profile() ?? IDContentProfile.create()
        profileModel.email = email
        profileModel.emailVerified = emailVerified
        profileModel.phone = phone
        profileModel.phoneVerified = phoneVerified
        profileModel.username = username
        profileModel.modifiedAt = Date()
        profileModel.isEntityDeleted = false
        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteProfile() {
        self.profile()?.deleteModel()
        SIDCoreDataManager.instance.saveContext()
    }
}
