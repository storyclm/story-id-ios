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
        completion(nil)
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

    @NSManaged public var isEntityDeleted: Bool
    @NSManaged public var code: String?
    @NSManaged public var issuedAt: Date?
    @NSManaged public var issuedBy: String?
    @NSManaged public var modifiedAt: Date?
    @NSManaged public var modifiedBy: String?
    @NSManaged public var profileId: String?
    @NSManaged public var sn: String?
    @NSManaged public var userId: String?
    @NSManaged public var verified: Bool
    @NSManaged public var verifiedAt: Date?
    @NSManaged public var verifiedBy: String?
    @NSManaged public var pages: NSSet?
}
