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

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfilePasportAPI.getPasport { serverPasport, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let serverPasport = serverPasport {
                let localPasport = self.passport()

                guard SIDServiceHelper.isDataUpdate(localDate: localPasport?.modifiedAt, serverDate: serverPasport.modifiedAt) == false else {
                    complete(error: nil)
                    return
                }

                if let localPasport = localPasport, let lModifiedAt = localPasport.modifiedAt, let sModifiedAt = serverPasport.modifiedAt, lModifiedAt > sModifiedAt {

                    localPasport.sn = serverPasport.sn
                    localPasport.code = serverPasport.code
                    localPasport.issuedAt = serverPasport.issuedAt
                    localPasport.issuedBy = serverPasport.issuedBy
                    self.updatePages(for: localPasport, pages: serverPasport.pages)

                    localPasport.isEntityDeleted = false
                    localPasport.profileId = serverPasport.profileId
                    localPasport.modifiedAt = serverPasport.modifiedAt
                    localPasport.modifiedBy = serverPasport.modifiedBy
                    localPasport.verified = serverPasport.verified ?? false
                    localPasport.verifiedAt = serverPasport.verifiedAt
                    localPasport.verifiedBy = serverPasport.verifiedBy

                    SIDCoreDataManager.instance.saveContext()
                }
                complete(error: nil)
            }
        }
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

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentPasport] = IDContentPasport.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentPasport] = []
        for model in modelsForDeletion {
            serverGroup.enter()

            let emptyModel = StoryProfileDTO(email: nil, emailVerified: nil, phone: nil, phoneVerified: nil, username: nil)
            ProfileAPI.updateProfile(body: emptyModel) { _, error in
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

    public func deletePasport() {
        self.passport()?.deleteModel()
        self.deletePasportImage(page: 0)
        self.deletePasportImage(page: 1)
        self.deletePasportImage(page: 2)
        SIDCoreDataManager.instance.saveContext()
    }

    private let pasportImageName = "SID.Pasport.Image"

    public func pasportImage(page: Int) -> UIImage? {
        return SIDImageManager.getImage(name: pasportImageName, page: page)
    }

    public func setPasportImage(_ image: UIImage?, page: Int) {
        if let image = image {
            SIDImageManager.saveImage(image, name: pasportImageName, page: page)
        } else {
            self.deletePasportImage(page: page)
        }
    }

    public func deletePasportImage(page: Int) {
        SIDImageManager.deleteImage(name: pasportImageName, page: page)
    }
}
