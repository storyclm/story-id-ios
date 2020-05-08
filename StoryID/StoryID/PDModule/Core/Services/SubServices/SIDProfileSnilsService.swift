//
//  SIDProfileSnilsService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

public class SIDProfileSnilsService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfileSNILSAPI.getSnils { serverSnils, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverSnils = serverSnils {
                let localSnils = self.snils()

                guard SIDServiceHelper.isDataUpdate(localDate: localSnils?.modifiedAt, serverDate: serverSnils.modifiedAt) == false else {
                    complete(error: nil)
                    return
                }

                if let localSnils = localSnils {
                    if let lModifiedAt = localSnils.modifiedAt, let sModifiedAt = serverSnils.modifiedAt, lModifiedAt > sModifiedAt {
                        self.updateLocalModel(localSnils, with: serverSnils)
                    }
                } else {
                    let newModel: IDContentSNILS = IDContentSNILS.create()
                    self.updateLocalModel(newModel, with: serverSnils)
                }

                complete(error: nil)
            } else {
                complete(error: nil)
            }
        }
    }

    private func updateLocalModel(_ localModel: IDContentSNILS, with serverModel: StorySNILS) {
        localModel.snils = serverModel.snils

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
        guard let modelsForDeletion: [IDContentSNILS] = IDContentSNILS.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentSNILS] = []
        for model in modelsForDeletion {
            serverGroup.enter()
            ProfileSNILSAPI.setSnils(body: StorySNILSDTO(snils: nil)) { _, error in
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

    public func snils() -> IDContentSNILS? {
        return IDContentSNILS.firstModel()
    }

    public func setSnils(_ snils: String?) {
        let snilsModel = self.snils() ?? IDContentSNILS.create()
        snilsModel.snils = snils
        snilsModel.modifiedAt = Date()
        snilsModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteSnils() {
        self.snils()?.deleteModel()
        self.deleteSnilsImage()
        SIDCoreDataManager.instance.saveContext()
    }

    private let snilsImageName = "SID.SNILS.Image"

    public func snilsImage() -> UIImage? {
        return SIDImageManager.getImage(name: snilsImageName)
    }

    public func setSnilsImage(_ image: UIImage?) {
        if let image = image {
            SIDImageManager.saveImage(image, name: snilsImageName)
            self.snils()?.updateModifyBy()
        } else {
            self.deleteSnilsImage()
        }
    }

    public func deleteSnilsImage() {
        SIDImageManager.deleteImage(name: snilsImageName)
        self.snils()?.updateModifyBy()
    }
}
