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

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {

        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfileDemographicsAPI.getDemographics { serverDemographics, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverDemographics = serverDemographics {
                let localDemographics = self.demographics()

                guard SIDServiceHelper.isDataUpdate(localDate: localDemographics?.modifiedAt, serverDate: serverDemographics.modifiedAt) == false else {
                    complete(error: nil)
                    return
                }

                if let localDemographics = localDemographics {
                    if let lModifiedAt = localDemographics.modifiedAt, let sModifiedAt = serverDemographics.modifiedAt, lModifiedAt > sModifiedAt {
                        self.updateLocalModel(localDemographics, with: serverDemographics)
                    }
                } else {
                    let newModel: IDContentDemographics = IDContentDemographics.create()
                    self.updateLocalModel(newModel, with: serverDemographics)
                }

                complete(error: nil)
            } else {
                complete(error: nil)
            }
        }
    }

    private func updateLocalModel(_ localModel: IDContentDemographics, with serverModel: StoryDemographics) {
        localModel.name = serverModel.name
        localModel.surname = serverModel.surname
        localModel.patronymic = serverModel.patronymic
        localModel.birthday = serverModel.birthday
        localModel.gender = serverModel.gender ?? false

        localModel.isEntityDeleted = false
        localModel.profileId = serverModel.profileId
        localModel.modifiedAt = serverModel.modifiedAt
        localModel.modifiedBy = serverModel.modifiedBy
        localModel.verified = serverModel.verified ?? false
        localModel.verifiedAt = serverModel.verifiedAt
        localModel.verifiedBy = serverModel.verifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentDemographics] = IDContentDemographics.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentDemographics] = []
        for model in modelsForDeletion {
            serverGroup.enter()
            ProfileDemographicsAPI.updateDemographics(body: StoryDemographicsDTO(name: nil, surname: nil, patronymic: nil, gender: nil, birthday: nil)) { _, error in
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

    public func deleteDemographics() {
        self.demographics()?.deleteModel()
        SIDCoreDataManager.instance.saveContext()
    }
}
