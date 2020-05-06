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
        completion(nil)
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
