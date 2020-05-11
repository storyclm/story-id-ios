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

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localSnils, serverDate: serverSnils.modifiedAt)

                switch updateBehaviour {
                case .update:
                    self.updateLocalModel(localSnils, with: serverSnils)
                    self.apiGetSnilsImage { image, error in
                        if let error = error {
                            complete(error: error.asServiceError)
                        } else {
                            SIDImageManager.saveImage(image, name: self.snilsImageName) { error in
                                complete(error: nil)
                            }
                        }
                    }
                case .send:
                    if let snils = localSnils {
                        self.sendSnils(snils: snils.snils) { _, error in
                            self.apiSendSnilsImage { model, error in
                                if let error = error {
                                    complete(error: error.asServiceError)
                                } else if let model = model {
                                    self.updateLocalModel(localSnils, with: model)
                                    complete(error: nil)
                                } else {
                                    complete(error: error?.asServiceError)
                                }
                            }
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

    private func updateLocalModel(_ localModel: IDContentSNILS?, with serverModel: StorySNILS, isCreateIfNeeded: Bool = true) {
        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentSNILS.create()
        }

        guard let lModel = localModel else { return }

        lModel.snils = serverModel.snils

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.verified = serverModel.verified ?? false
        lModel.verifiedAt = serverModel.verifiedAt
        lModel.verifiedBy = serverModel.verifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func sendSnils(snils: String?, completion: @escaping (StorySNILS?, Error?) -> Void) {
        let body = StorySNILSDTO(snils: snils)
        ProfileSNILSAPI.setSnils(body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentSNILS] = IDContentSNILS.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentSNILS] = []
        for model in modelsForDeletion {
            serverGroup.enter()
            self.sendSnils(snils: nil) { _, error in
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

    // MARK: * Image

    private func apiGetSnilsImage(completion: @escaping (UIImage?, Error?) -> Void) {
        SIDLegacyImageLoader.instance.getImage(with: "/profile/snils/download", parameters: nil, completion: completion)
    }

    private func apiSendSnilsImage(completion: @escaping (StorySNILS?, Error?) -> Void) {
        self.snilsImage { image in
            guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
                completion(nil, nil)
                return
            }

            let file = FileParam(data: imageData, name: "file")
            SIDLegacyImageLoader.instance.loadFiles(to: "/profile/snils/upload", files: [file], parameters: nil, completion: completion)
        }
    }

    private func apiDeleteSnilsImage(completion: @escaping (StorySNILS?, Error?) -> Void) {
        SIDLegacyImageLoader.instance.deleteFile(at: "/profile/snils/upload", completion: completion)
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
        self.snils()?.isEntityDeleted = true
        self.deleteSnilsImage()
        SIDCoreDataManager.instance.saveContext()
    }

    private let snilsImageName = "SID.SNILS.Image"

    public func snilsImage(completion: @escaping (UIImage?) -> Void) {
        SIDImageManager.getImage(name: snilsImageName) { image, _ in
            completion(image)
        }
    }

    public func setSnilsImage(_ image: UIImage?) {
        if let image = image {
            SIDImageManager.saveImage(image, name: snilsImageName) {[weak self] error in
                if error == nil {
                    try? self?.snils()?.updateModifyAt()
                }
            }
        } else {
            self.deleteSnilsImage()
        }
    }

    public func deleteSnilsImage() {
        SIDImageManager.deleteImage(name: snilsImageName) {[weak self] success in
            try? self?.snils()?.updateModifyAt()
        }
    }
}
