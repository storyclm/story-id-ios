//
//  SIDProfilePasportService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

public class SIDProfilePasportService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true
    public private(set) var isSynchronizing: Bool = false

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
        ProfilePasportAPI.getPasport { serverPasport, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverPasport = serverPasport {
                let localPasport = self.passport()

                let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localPasport, serverDate: serverPasport.modifiedAt)

                switch updateBehaviour {
                case .update:
                    self.updateLocalModel(localPasport, with: serverPasport)
                    complete(error: nil)
                case .send:
                    if let localPasport = localPasport {
                        self.sendPasport(sn: localPasport.sn,
                                         issuedBy: localPasport.issuedBy,
                                         issuedAt: localPasport.issuedAt,
                                         code: localPasport.code,
                                         pages: self.convertLocalPagesToServer(localPasport.pages)) { _, error in
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
    private func updateLocalModel(_ localModel: IDContentPasport?, with serverModel: StoryPasport, isCreateIfNeeded: Bool = true) -> IDContentPasport? {

        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentPasport.create()
        }

        guard let lModel = localModel else { return nil }

        lModel.sn = serverModel.sn
        lModel.code = serverModel.code
        lModel.issuedAt = serverModel.issuedAt
        lModel.issuedBy = serverModel.issuedBy

        (lModel.pages as? Set<IDContentPasportPage>)?.forEach { lModel.removeFromPages($0) }
        if let pages = self.convertServerPagesToLocal(serverModel.pages) {
            lModel.addToPages(pages)
        }

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.verified = serverModel.verified ?? false
        lModel.verifiedAt = serverModel.verifiedAt
        lModel.verifiedBy = serverModel.verifiedBy

        SIDCoreDataManager.instance.saveContext()

        return lModel
    }

    private func sendPasport(sn: String?,
                             issuedBy: String?,
                             issuedAt: Date?,
                             code: String?,
                             pages: [StoryPasportPageViewModel]?,
                             completion: @escaping (StoryPasport?, Error?) -> Void) {
        let body = StoryPasportDTO(sn: sn, issuedBy: issuedBy, issuedAt: issuedAt, code: code, pages: pages)
        ProfilePasportAPI.setPasport(body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentPasport] = IDContentPasport.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentPasport] = []
        for model in modelsForDeletion {
            serverGroup.enter()

            self.sendPasport(sn: nil, issuedBy: nil, issuedAt: nil, code: nil, pages: nil) { _, error in
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

    // MARK: - Pages

    func convertLocalPagesToServer(_ pages: NSSet?) -> [StoryPasportPageViewModel]? {
        guard let pages = pages as? Set<IDContentPasportPage> else { return nil }

        return pages.map { StoryPasportPageViewModel(modifiedAt: $0.modifiedAt, modifiedBy: $0.modifiedBy, size: $0.size, mimeType: $0.mimeType, page: Int($0.page)) }
    }

    func convertServerPagesToLocal(_ pages: [StoryPasportPageViewModel]?) -> NSSet? {
        guard let pages = pages else { return nil }

        let result = pages.map {
            let localPage: IDContentPasportPage = IDContentPasportPage.create()
            localPage.size = $0.size ?? 0
            localPage.mimeType = $0.mimeType
            localPage.page = Int32($0.page)
            localPage.modifiedAt = $0.modifiedAt
            localPage.modifiedBy = $0.modifiedBy
            return localPage
        }
        .reduce(into: Set<IDContentPasportPage>()) { $0.insert($1) }

        return result as NSSet
    }

    func updatePages(for content: IDContentPasport, pages: [StoryPasportPageViewModel]?) {
        guard let pages = pages else {
            return
        }

        (content.pages as? Set<IDContentPasportPage>)?.forEach { content.removeFromPages($0) }

        for page in pages {
            let localPage: IDContentPasportPage = IDContentPasportPage.create()
            localPage.size = page.size ?? 0
            localPage.mimeType = page.mimeType
            localPage.page = Int32(page.page)
            localPage.modifiedAt = page.modifiedAt
            localPage.modifiedBy = page.modifiedBy

            content.addToPages(localPage)
        }
    }

    // MARK: - Public

    public func passport() -> IDContentPasport? {
        return IDContentPasport.firstModel()
    }

    public func setPasport(code: String?, sn: String?, issuedBy: String?, issuedAt: Date?) {
        let pasportModel = self.passport() ?? IDContentPasport.create()
        pasportModel.code = code
        pasportModel.sn = sn
        pasportModel.issuedAt = issuedAt
        pasportModel.issuedBy = issuedBy
        pasportModel.modifiedAt = Date()
        pasportModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func updatePasport(code: String?, sn: String?, issuedBy: String?, issuedAt: Date?) {
        let pasportModel = self.passport() ?? IDContentPasport.create()
        if let code = code {
            pasportModel.code = code
        }
        if let sn = sn {
            pasportModel.sn = sn
        }
        if let issuedAt = issuedAt {
            pasportModel.issuedAt = issuedAt
        }
        if let issuedBy = issuedBy {
            pasportModel.issuedBy = issuedBy
        }
        pasportModel.modifiedAt = Date()
        pasportModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func markPasportDeleted() {
        self.passport()?.isEntityDeleted = true
        self.deletePasportImage(page: 0)
        self.deletePasportImage(page: 1)
        self.deletePasportImage(page: 2)
        SIDCoreDataManager.instance.saveContext()
    }

    public func deletePasport() {
        self.passport()?.deleteModel()
        self.deletePasportImage(page: 0)
        self.deletePasportImage(page: 1)
        self.deletePasportImage(page: 2)
        SIDCoreDataManager.instance.saveContext()
    }

    private let pasportImageName = "SID.Pasport.Image"

    public func pasportImage(page: Int, completion: @escaping (UIImage?) -> Void) {
        SIDImageManager.getImage(name: pasportImageName, page: page) { image, _ in
            completion(image)
        }
    }

    public func setPasportImage(_ image: UIImage?, page: Int) {
        if let image = image {
            SIDImageManager.saveImage(image, name: pasportImageName, page: page) {[weak self] error in
                if error == nil {
                    try? self?.passport()?.updateModifyAt()
                }
            }
        } else {
            self.deletePasportImage(page: page)
        }
    }

    public func deletePasportImage(page: Int) {
        SIDImageManager.deleteImage(name: pasportImageName, page: page) {[weak self] success in
            if success {
                try? self?.passport()?.updateModifyAt()
            }
        }

    }
}
