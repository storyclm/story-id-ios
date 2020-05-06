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
        completion(nil)
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
