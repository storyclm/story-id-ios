//
//  SIDImageManager.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class SIDImageManager {

    enum ImageManagerSaveError {
        case dataConversionError
        case documentPathError
        case writeError
    }

    // MARK: - URLs

    static var documentsDirectory: URL? {
        FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
    }

    static var imageDirectory: URL? {
        guard let dir = documentsDirectory?.appendingPathComponent("idContentImages") else { return nil}

        if isDirectoryExist(dir) == false {
            do {
                try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: false, attributes: nil)
                return dir
            } catch {
                return nil
            }
        }
        return dir
    }

    class func imageURL(name: String, page: Int, userId: String?) -> URL? {
        var imageName = userId ?? ""
        imageName = "\(imageName)_\(name)_\(page).png"
        return self.imageDirectory?.appendingPathComponent(imageName, isDirectory: false)
    }

    class func isDirectoryExist(_ url: URL) -> Bool {
        var isDirectory = ObjCBool(true)
        let isExists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isExists && isDirectory.boolValue
    }

    static func fileExists(_ url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    // MARK: -

    @discardableResult
    class func saveImage(_ image: UIImage, name: String, page: Int = 1, userId: String? = SIDServiceHelper.userId) -> ImageManagerSaveError? {
        guard let imageData = image.pngData() else {
            return ImageManagerSaveError.dataConversionError
        }

        guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else {
            return ImageManagerSaveError.documentPathError
        }

        self.deleteImage(name: name, page: page)

        var writeData = imageData
        if SIDSettings.instance.isCryptoEnabled {
            writeData = SIDCryptoManager.instance.encrypt(imageData)
        }

        do {
            try writeData.write(to: imageURL)
            return nil
        } catch {
            return ImageManagerSaveError.writeError
        }
    }

    class func getImage(name: String, page: Int = 1, userId: String? = SIDServiceHelper.userId) -> UIImage? {
        guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else { return nil }
        guard fileExists(imageURL) else { return nil }

        guard let imageData = FileManager.default.contents(atPath: imageURL.path) else { return nil }

        var readData = imageData
        if SIDSettings.instance.isCryptoEnabled {
            guard let encryptedData: Data = SIDCryptoManager.instance.decrypt(data: imageData) else { return nil }
            readData = encryptedData
        }

        return UIImage(data: readData)
    }

    @discardableResult
    class func deleteImage(name: String, page: Int = 1, userId: String? = SIDServiceHelper.userId) -> Bool {
        guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else { return false }

        do {
            try FileManager.default.removeItem(at: imageURL)
            return true
        } catch {
            return false
        }
    }

}
