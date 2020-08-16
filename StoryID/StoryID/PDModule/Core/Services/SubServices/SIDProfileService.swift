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
    public private(set) var isSynchronizing: Bool = false

    private let observers = SIDObserveManager()

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        guard isSynchronizing == false else {
            completion(.alreadyInSync)
            return
        }

        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
            self.isSynchronizing = false
        }

        self.isSynchronizing = true
        ProfileAPI.getProfile { serverProfile, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverProfile = serverProfile {
                let localProfile = self.profile()

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localProfile, serverDate: serverProfile.modifiedAt)

                switch updateBehaviour {
                case .update:
                    let updatedModel = self.updateLocalModel(localProfile, with: serverProfile)
                    self.notifyObservers(with: updatedModel)
                    complete(error: nil)
                case .send:
                    if let profile = localProfile {
                        self.sendProfile(email: profile.email,
                                         emailVerified: profile.emailVerified,
                                         phone: profile.phone,
                                         phoneVerified: profile.phoneVerified,
                                         userName: profile.username) { _, error in
                                            complete(error: error?.asServiceError)
                        }
                    }
                case .skip:
                    complete(error: nil)
                }
            } else {
                complete(error: nil)
            }
        }
    }

    @discardableResult
    private func updateLocalModel(_ localModel: IDContentProfile?, with serverModel: StoryProfile, isCreateIfNeeded: Bool = true) -> IDContentProfile? {
        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentSNILS.create()
        }

        guard let lModel = localModel else { return nil }

        lModel.username = serverModel.username
        lModel.email = serverModel.email
        lModel.emailVerified = serverModel.emailVerified ?? false
        lModel.phone = serverModel.phone
        lModel.phoneVerified = serverModel.phoneVerified ?? false

        lModel.isEntityDeleted = false
        lModel.id = serverModel._id
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.createdAt = serverModel.createdAt
        lModel.createdBy = serverModel.createdBy

        SIDCoreDataManager.instance.saveContext()

        return lModel
    }

    private func sendProfile(email: String?,
                             emailVerified: Bool?,
                             phone: String?,
                             phoneVerified: Bool?,
                             userName: String?,
                             completion: @escaping (StoryProfile?, Error?) -> Void) {
        let body = StoryProfileDTO(email: email, emailVerified: emailVerified, phone: phone, phoneVerified: phoneVerified, username: userName)
        ProfileAPI.updateProfile(body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentProfile] = IDContentProfile.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentProfile] = []
        for model in modelsForDeletion {
            serverGroup.enter()

            self.sendProfile(email: nil, emailVerified: nil, phone: nil, phoneVerified: nil, userName: nil) { _, error in
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

    // MARK: - Observer

    public func addObserver(_ observer: AnyObject, callback: @escaping (IDContentProfile?) -> Void) {
        callback(self.profile())

        self.observers.addObserver(observer, type: SIDObserveManager.SIDObserver.ObserveType.both) { model in
            guard let model = model as? IDContentProfile else { return }
            callback(model)
        }
    }

    public func removeObserver(_ observer: AnyObject) {
        self.observers.removeObserver(observer)
    }

    private func notifyObservers(with model: IDContentProfile?) {
        for observer in self.observers.allObserver(with: .model) {
            observer.value.callback(model as AnyObject?)
        }
    }

    // MARK: - Public

    public func profile() -> IDContentProfile? {
        return IDContentProfile.firstModel()
    }

    public func setProfile(email: String?, emailVerified: Bool, phone: String?, phoneVerified: Bool, username: String?) {
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

    public func updateProfile(email: String?,
                              emailVerified: Bool?,
                              phone: String?,
                              phoneVerified: Bool?,
                              username: String?) {
        let profileModel = self.profile() ?? IDContentProfile.create()
        if let email = email {
            profileModel.email = email
        }
        if let emailVerified = emailVerified {
            profileModel.emailVerified = emailVerified
        }
        if let phone = phone {
            profileModel.phone = phone
        }
        if let phoneVerified = phoneVerified {
            profileModel.phoneVerified = phoneVerified
        }
        if let username = username {
            profileModel.username = username
        }

        profileModel.modifiedAt = Date()
        profileModel.isEntityDeleted = false
        SIDCoreDataManager.instance.saveContext()
    }

    public func markProfileAsDeleted() {
        self.profile()?.isEntityDeleted = true
        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteProfile() {
        self.profile()?.deleteModel()
        SIDCoreDataManager.instance.saveContext()
    }
}
