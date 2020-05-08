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
        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfileAPI.getProfile { serverProfile, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverProfile = serverProfile {
                let localProfile = self.profile()

                guard SIDServiceHelper.isDataUpdate(localDate: localProfile?.modifiedAt, serverDate: serverProfile.modifiedAt) == false else {
                    complete(error: nil)
                    return
                }
                if let localProfile = localProfile {
                    if let lModifiedAt = localProfile.modifiedAt, let sModifiedAt = serverProfile.modifiedAt, lModifiedAt > sModifiedAt {
                        self.updateLocalModel(localProfile, with: serverProfile)
                    }
                } else {
                    let newModel: IDContentProfile = IDContentProfile.create()
                    self.updateLocalModel(newModel, with: serverProfile)
                }

                complete(error: nil)
            } else {
                complete(error: nil)
            }
        }
    }

    private func updateLocalModel(_ localModel: IDContentProfile, with serverModel: StoryProfile) {
        localModel.id = serverModel._id
        localModel.username = serverModel.username
        localModel.email = serverModel.email
        localModel.emailVerified = serverModel.emailVerified ?? false
        localModel.phone = serverModel.phone
        localModel.phoneVerified = serverModel.phoneVerified ?? false
        localModel.createdAt = serverModel.createdAt
        localModel.createdBy = serverModel.createdBy

        localModel.isEntityDeleted = false
        localModel.modifiedAt = serverModel.modifiedAt
        localModel.modifiedBy = serverModel.modifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentProfile] = IDContentProfile.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentProfile] = []
        for model in modelsForDeletion {
            serverGroup.enter()

            let emptyModel = StoryProfileDTO(email: nil, emailVerified: nil, phone: nil, phoneVerified: nil, username: nil)

            ProfileAPI.updateProfile(body: emptyModel) { _, error in
                if error == nil {
                    deletedModels.append(model)
                }
                serverGroup.leave()
            }
        }

        serverGroup.notify(queue: DispatchQueue.main) {
            deletedModels.forEach { $0.deleteModel() }
        }

        SIDCoreDataManager.instance.saveContext()
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
