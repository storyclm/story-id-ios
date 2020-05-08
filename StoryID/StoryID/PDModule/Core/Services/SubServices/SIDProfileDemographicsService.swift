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

                if let localDemographics = localDemographics, let lModifiedAt = localDemographics.modifiedAt, let sModifiedAt = serverDemographics.modifiedAt, lModifiedAt > sModifiedAt {

                    localDemographics.name = serverDemographics.name
                    localDemographics.surname = serverDemographics.surname
                    localDemographics.patronymic = serverDemographics.patronymic
                    localDemographics.birthday = serverDemographics.birthday
                    localDemographics.gender = serverDemographics.gender ?? false

                    localDemographics.isEntityDeleted = false
                    localDemographics.profileId = serverDemographics.profileId
                    localDemographics.modifiedAt = serverDemographics.modifiedAt
                    localDemographics.modifiedBy = serverDemographics.modifiedBy
                    localDemographics.verified = serverDemographics.verified ?? false
                    localDemographics.verifiedAt = serverDemographics.verifiedAt
                    localDemographics.verifiedBy = serverDemographics.verifiedBy

                    SIDCoreDataManager.instance.saveContext()
                }
                complete(error: nil)
            }
        }
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
