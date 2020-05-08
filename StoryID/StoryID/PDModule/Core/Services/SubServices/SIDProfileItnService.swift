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

                guard SIDServiceHelper.isDataUpdate(localDate: localItn?.modifiedAt, serverDate: serverItn.modifiedAt) == false else {
                    complete(error: nil)
                    return
                }

                if let localItn = localItn, let lModifiedAt = localItn.modifiedAt, let sModifiedAt = serverItn.modifiedAt, lModifiedAt > sModifiedAt {
                    localItn.itn = serverItn.itn

                    localItn.isEntityDeleted = false
                    localItn.profileId = serverItn.profileId
                    localItn.modifiedAt = serverItn.modifiedAt
                    localItn.modifiedBy = serverItn.modifiedBy
                    localItn.verified = serverItn.verified ?? false
                    localItn.verifiedAt = serverItn.verifiedAt
                    localItn.verifiedBy = serverItn.verifiedBy

                    SIDCoreDataManager.instance.saveContext()
                }
                complete(error: nil)
            }
        }
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentITN] = IDContentITN.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentITN] = []
        for model in modelsForDeletion {
            serverGroup.enter()
            ProfileITNAPI.setItn(body: StoryITNDTO(itn: nil)) { _, error in
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
        self.itn()?.deleteModel()
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
            self.itn()?.updateModifyBy()
        } else {
            self.deleteItnImage()
        }
    }

    public func deleteItnImage() {
        SIDImageManager.deleteImage(name: itnImageName)
        self.itn()?.updateModifyBy()
    }
}
