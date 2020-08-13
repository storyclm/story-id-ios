//
//  SIDProfileAvatarService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 15.06.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

public class SIDProfileAvatarService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true
    public private(set) var isSynchronizing: Bool = false

    public var category: String?
    public var name: String?

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

        guard let category = self.category, let name = self.name else {
            complete(error: nil)
            return
        }

        self.isSynchronizing = true

        ProfileFilesAPI.getCategoryFileByName(category: category, name: name) { serverFileModel, error in
                if let error = error {
                if case let StoryID.ErrorResponse.error(code, _, _) = error, code == 404 {
                    self.apiCreateProfileFile { model, error in
                        if let model = model {
                            let localModel = self.avatarFileModel()
                            self.updateLocalModel(localModel, with: model)
                            self.notifyModelObservers(model: localModel)
                        }

                        complete(error: error?.asServiceError)
                    }
                } else {
                    complete(error: error.asServiceError)
                }
            } else if let serverFileModel = serverFileModel {
                let localFileModel = self.avatarFileModel()

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localFileModel, serverDate: serverFileModel.modifiedAt)
                self.syncHandler(updateBehaviour: updateBehaviour, localModel: localFileModel, serverModel: serverFileModel) { error in
                    complete(error: error?.asServiceError)
                }
            } else {
                complete(error: nil)
            }
        }
    }

    private func syncHandler(updateBehaviour: SIDServiceHelper.ServiceUpdateBehaviour,
                             localModel: IDContentFile?,
                             serverModel: FileViewModel?,
                             completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
            self.isSynchronizing = false
        }

        switch updateBehaviour {
        case .update:
            guard let serverModel = serverModel else {
                completion(nil)
                return
            }

            self.apiGetAvatarImage { image, error in
                if let error = error {
                    completion(error.asServiceError)
                } else {
                    self.updateLocalModel(localModel, with: serverModel)
                    self.notifyModelObservers(model: localModel)
                    self.saveImageToDisk(image)
                }
            }
        case .send:
            if let fileModel = localModel, let id = fileModel.id, let name = fileModel.name {
                self.sendAvatarFile(id: id,
                                    name: name,
                                    fileName: fileModel.fileName,
                                    mimeType: fileModel.mimeType,
                                    category: fileModel.category,
                                    description: fileModel.fileDescription) { model, error in
                                        if let error = error {
                                            completion(error.asServiceError)
                                        } else if let model = model {
                                            self.updateLocalModel(fileModel, with: model)
                                            self.notifyModelObservers(model: fileModel)
                                            completion(nil)
                                        } else {
                                            completion(nil)
                                        }
                }
            } else {
                completion(nil)
            }
        case .skip:
            completion(nil)
        }
    }

    private func apiCreateProfileFile(completion: @escaping (FileViewModel?, Error?) -> Void) {
        guard let name = self.name, let category = self.category else {
            completion(nil, nil)
            return
        }

        let body = CreateFileViewModel(name: name, category: category, _description: nil)
        ProfileFilesAPI.createFile(body: body) { fileViewModel, error in
            if let serverFile = fileViewModel {
                self.updateLocalModel(self.avatarFileModel(), with: serverFile)
                self.apiSendAvatarImage { (serverFileModel, error) in
                    if let model = serverFileModel {
                        self.updateLocalModel(self.avatarFileModel(), with: model)
                        completion(model, nil)
                    } else {
                        completion(nil, error?.asServiceError)
                    }
                }
            } else {
                completion(nil, error?.asServiceError)
            }
        }
    }

    private func updateLocalModel(_ localModel: IDContentFile?, with serverModel: FileViewModel, isCreateIfNeeded: Bool = true) {
        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentFile.create()
        }

        guard let lModel = localModel else { return }

        lModel.name = serverModel.name
        lModel.fileDescription = serverModel._description

        lModel.fileName = serverModel.fileName
        lModel.size = serverModel.size ?? 0
        lModel.mimeType = serverModel.mimeType
        lModel.category = serverModel.category
        lModel.isUploaded = serverModel.uploaded ?? false

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.id = serverModel._id
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.createdAt = serverModel.createdAt

        SIDCoreDataManager.instance.saveContext()
    }

    private func sendAvatarFile(id: String,
                                name: String,
                                fileName: String?,
                                mimeType: String?,
                                category: String?,
                                description: String?,
                                completion: @escaping (FileViewModel?, Error?) -> Void) {
        let body = UpdateFileViewModel(fileName: fileName, mimeType: mimeType, name: name, category: category, _description: description)
        ProfileFilesAPI.updateFileMetadata(_id: id, body: body) { fileViewModel, error in
            if let serverFile = fileViewModel {
                self.updateLocalModel(self.avatarFileModel(), with: serverFile)
                self.apiSendAvatarImage { (serverFileModel, error) in
                    if let model = serverFileModel {
                        self.updateLocalModel(self.avatarFileModel(), with: model)
                        completion(model, nil)
                    } else {
                        completion(nil, error?.asServiceError)
                    }
                }
            } else {
                completion(nil, error?.asServiceError)
            }
        }
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentFile] = IDContentFile.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }
        //
        let serverGroup = DispatchGroup()
        //
        var deletedModels: [IDContentFile] = []
        for model in modelsForDeletion {
            guard let id = model.id, let name = model.name else { continue }

            serverGroup.enter()

            self.sendAvatarFile(id: id, name: name, fileName: nil, mimeType: nil, category: nil, description: nil) { _, error in
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

    private func apiGetAvatarImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let category = self.category, let name = self.name else {
            completion(nil, nil)
            return
        }

        SIDLegacyFileLoader.instance.getFile(category: category, name: name) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    private func apiSendAvatarImage(completion: @escaping (FileViewModel?, Error?) -> Void) {
        guard let category = self.category, let name = self.name else {
            completion(nil, nil)
            return
        }

        self.avatarImage { image in
            guard let imageData = image?.jpegData(compressionQuality: 1.0) else {
                completion(nil, nil)
                return
            }

            SIDLegacyFileLoader.instance.uploadFile(category: category, name: name, data: imageData, completion: completion)
        }
    }

    private func apiDeleteAvatarImage(completion: @escaping (FileViewModel?, Error?) -> Void) {
        self.avatarImage { image in
            guard image != nil, let imageid = self.avatarFileModel()?.id else {
                completion(nil, nil)
                return
            }

            SIDLegacyFileLoader.instance.deleteFile(with: imageid, completion: completion)
        }
    }

    private func saveImageToDisk(_ image: UIImage?) {
        SIDImageManager.saveImage(image, name: avatarImageName) {[weak self] error in
            if error == nil {
                try? self?.avatarFileModel()?.updateModifyAt()
            }
            self?.notifyImageObservers(image: image)
        }
    }

    // MARK: - Observer

    public func addObserver(_ observer: AnyObject, type: SIDObserveManager.SIDObserver.ObserveType, callback: @escaping (AnyObject?) -> Void) {
        if type == .both || type == .model {
            callback(self.avatarFileModel())
        } else if type == .both || type == .image {
            self.avatarImage {[weak observer] avatar in
                if let observer = observer, let callback = self.observers[observer]?.callback {
                    callback(avatar)
                }
            }
        }
        self.observers.addObserver(observer, type: type, callback: callback)
    }

    public func removeObserver(_ observer: AnyObject) {
        self.observers.removeObserver(observer)
    }

    public func notifyModelObservers(model: IDContentFile?) {
        for observer in self.observers.allObserver(with: SIDObserveManager.SIDObserver.ObserveType.model) {
            observer.value.callback(model as AnyObject?)
        }
    }

    public func notifyImageObservers(image: UIImage?) {
        for observer in self.observers.allObserver(with: SIDObserveManager.SIDObserver.ObserveType.image) {
            observer.value.callback(image)
        }
    }

    // MARK: - Public

    public func avatarFileModel() -> IDContentFile? {
        return IDContentFile.firstModel(userID: nil)
    }

    public func setAvatarFileModel(id: String,
                                   name: String,
                                   fileName: String?,
                                   mimeType: String?,
                                   category: String?,
                                   description: String?) {
        let avatarModel = self.avatarFileModel() ?? IDContentFile.create()
        avatarModel.id = id
        avatarModel.name = name
        avatarModel.fileDescription = description

        avatarModel.fileName = fileName
        avatarModel.mimeType = mimeType
        avatarModel.category = category
        avatarModel.isUploaded = false

        avatarModel.isEntityDeleted = false
        avatarModel.profileId = nil
        avatarModel.modifiedAt = Date()
        avatarModel.createdAt = Date()

        SIDCoreDataManager.instance.saveContext()
    }

    public func updateAvatarFileModel(id: String,
                                      name: String,
                                      fileName: String?,
                                      mimeType: String?,
                                      category: String?,
                                      description: String?) {

        let avatarModel = self.avatarFileModel() ?? IDContentFile.create()
        avatarModel.id = id
        avatarModel.name = name

        if let description = description {
            avatarModel.fileDescription = description
        }

        if let fileName = fileName {
            avatarModel.fileName = fileName
        }
        if let mimeType = mimeType {
            avatarModel.mimeType = mimeType
        }
        if let category = category {
            avatarModel.category = category
        }

        avatarModel.isEntityDeleted = false
        avatarModel.modifiedAt = Date()

        SIDCoreDataManager.instance.saveContext()
    }

    public func markAvatarFileAsDeleted() {
        self.avatarFileModel()?.isEntityDeleted = true
        self.deleteAvatarImage()
        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteAvatarFile() {
        self.avatarFileModel()?.deleteModel()
        self.deleteAvatarImage()
        SIDCoreDataManager.instance.saveContext()
    }

    private let avatarImageName = "SID.AVATAR.Image"
    public func avatarImage(completion: @escaping (UIImage?) -> Void) {
        SIDImageManager.getImage(name: avatarImageName) { image, _ in
            completion(image)
        }
    }

    public func setAvatarImage(_ image: UIImage?, isSkipModifyAt: Bool = false) {
        if let image = image {
            if self.avatarFileModel() == nil {
                self.setAvatarFileModel(id: UUID().uuidString, name: self.name ?? "file", fileName: "file", mimeType: nil, category: self.category, description: nil)
            }
            self.saveImageToDisk(image)
        } else {
            self.deleteAvatarImage()
        }
    }

    public func deleteAvatarImage() {
        SIDImageManager.deleteImage(name: avatarImageName) {[weak self] success in
            if success {
                try? self?.avatarFileModel()?.updateModifyAt()
            }
            self?.notifyImageObservers(image: nil)
        }

    }
}
