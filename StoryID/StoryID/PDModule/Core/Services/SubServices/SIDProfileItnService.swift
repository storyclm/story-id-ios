//
//  SIDProfileItnService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 06.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

public class SIDProfileItnService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {

        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfileITNAPI.getItn { serverItn, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverItn = serverItn {
                let localItn = self.itn()

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localItn, serverDate: serverItn.modifiedAt)
                switch updateBehaviour {
                case .update:
                    self.updateLocalModel(localItn, with: serverItn)
                    complete(error: nil)
                case .send:
                    if let itn = localItn?.itn {
                        self.sendItn(itn) { _, error in
                            completion(error?.asServiceError)
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

    private func updateLocalModel(_ localModel: IDContentITN?, with serverModel: StoryITN, isCreateIfNeeded: Bool = true) {
        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentITN.create()
        }

        guard let lModel = localModel else { return }

        lModel.itn = serverModel.itn
        lModel.size = serverModel.size ?? 0
        lModel.mimeType = serverModel.mimeType

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.verified = serverModel.verified ?? false
        lModel.verifiedAt = serverModel.verifiedAt
        lModel.verifiedBy = serverModel.verifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func sendItn(_ itn: String?, completion: @escaping (StoryITN?, Error?) -> Void) {
        let body = StoryITNDTO(itn: itn)
        ProfileITNAPI.setItn(body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentITN] = IDContentITN.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentITN] = []
        for model in modelsForDeletion {
            serverGroup.enter()
            self.sendItn(nil) { _, error in
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

    public func itn() -> IDContentITN? {
        return IDContentITN.firstModel()
    }

    public func setItn(itn: String?) {
        let itnModel = self.itn() ?? IDContentITN.create()
        itnModel.itn = itn
        itnModel.modifiedAt = Date()
        itnModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteItn() {
        self.itn()?.isEntityDeleted = true
        self.deleteItnImage()
        SIDCoreDataManager.instance.saveContext()
    }

    private let itnImageName = "SID.ITN.Image"

    public func itnImage() -> UIImage? {
        return SIDImageManager.getImage(name: itnImageName)
    }

    public func setItnImage(_ image: UIImage?) {
        if let image = image {
            SIDImageManager.saveImage(image, name: itnImageName)
            try? self.itn()?.updateModifyAt()
        } else {
            self.deleteItnImage()
        }
    }

    public func deleteItnImage() {
        SIDImageManager.deleteImage(name: itnImageName)
        try? self.itn()?.updateModifyAt()
    }
}
