//
//  SIDProfileDemographicsService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public class SIDProfileDemographicsService: SIDServiceProtocol {

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
        ProfileDemographicsAPI.getDemographics { serverDemographics, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverDemographics = serverDemographics {
                let localDemographics = self.demographics()

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localDemographics, serverDate: serverDemographics.modifiedAt)

                switch updateBehaviour {
                case .update:
                    self.updateLocalModel(localDemographics, with: serverDemographics)
                    self.notifyObservers(with: localDemographics)
                    complete(error: nil)
                case .send:
                    if let demographics = localDemographics {
                        self.sendDemographics(name: demographics.name,
                                              surname: demographics.surname,
                                              patronymic: demographics.patronymic,
                                              gender: demographics.gender,
                                              birthday: demographics.birthday) { _, error in
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

    private func updateLocalModel(_ localModel: IDContentDemographics?, with serverModel: StoryDemographics, isCreateIfNeeded: Bool = true) {
        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentDemographics.create()
        }

        guard let lModel = localModel else { return }

        lModel.name = serverModel.name
        lModel.surname = serverModel.surname
        lModel.patronymic = serverModel.patronymic
        lModel.birthday = serverModel.birthday
        lModel.gender = serverModel.gender ?? false

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.verified = serverModel.verified ?? false
        lModel.verifiedAt = serverModel.verifiedAt
        lModel.verifiedBy = serverModel.verifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func sendDemographics(name: String?,
                                  surname: String?,
                                  patronymic: String?,
                                  gender: Bool?,
                                  birthday: Date?,
                                  completion: @escaping (StoryDemographics?, Error?) -> Void) {
        let body = StoryDemographicsDTO(name: name, surname: surname, patronymic: patronymic, gender: gender, birthday: birthday)
        ProfileDemographicsAPI.updateDemographics(body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentDemographics] = IDContentDemographics.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentDemographics] = []
        for model in modelsForDeletion {
            serverGroup.enter()

            self.sendDemographics(name: nil, surname: nil, patronymic: nil, gender: nil, birthday: nil) { _, error in
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

    public func addObserver(_ observer: AnyObject, callback: @escaping (IDContentDemographics?) -> Void) {
        callback(self.demographics())

        self.observers.addObserver(observer, type: SIDObserveManager.SIDObserver.ObserveType.both) { model in
            guard let model = model as? IDContentDemographics else { return }
            callback(model)
        }
    }

    public func removeObserver(_ observer: AnyObject) {
        self.observers.removeObserver(observer)
    }

    private func notifyObservers(with model: IDContentDemographics?) {
        for observer in self.observers.allObserver(with: .model) {
            observer.value.callback(model as AnyObject?)
        }
    }

    // MARK: - Public

    public func demographics() -> IDContentDemographics? {
        return IDContentDemographics.firstModel()
    }

    public func setDemographics(name: String?, surname: String?, patronymic: String?, gender: Bool, birthday: Date?) {
        let demographicsModel = self.demographics() ?? IDContentDemographics.create()
        demographicsModel.name = name
        demographicsModel.surname = surname
        demographicsModel.patronymic = patronymic
        demographicsModel.gender = gender
        demographicsModel.birthday = birthday
        demographicsModel.modifiedAt = Date()
        demographicsModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func updateDemographics(name: String?, surname: String?, patronymic: String?, gender: Bool?, birthday: Date?) {
        let demographicsModel = self.demographics() ?? IDContentDemographics.create()

        if let name = name {
            demographicsModel.name = name
        }
        if let surname = surname {
            demographicsModel.surname = surname
        }
        if let patronymic = patronymic {
            demographicsModel.patronymic = patronymic
        }
        if let gender = gender {
            demographicsModel.gender = gender
        }
        if let birthday = birthday {
            demographicsModel.birthday = birthday
        }
        demographicsModel.isEntityDeleted = false
        demographicsModel.modifiedAt = Date()

        SIDCoreDataManager.instance.saveContext()
    }

    public func markDemographicsDeleted() {
        self.demographics()?.isEntityDeleted = true
        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteDemographics() {
        self.demographics()?.deleteModel()
        SIDCoreDataManager.instance.saveContext()
    }
}
