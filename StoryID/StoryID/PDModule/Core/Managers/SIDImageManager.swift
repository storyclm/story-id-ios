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
        case imageIsMissing
        case dataConversionError
        case documentPathError
        case writeError
    }

    enum ImageManagerGetError {
        case documentIsPathWrong
        case imageNotExist
        case dataConversionError
        case decryptionError
        case dataReadError
    }

    // MARK: - URLs

    static var documentsDirectory: URL? {
        FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
    }

    static var imageDirectory: URL? {
        guard let dir = documentsDirectory?.appendingPathComponent("idContentImages") else { return nil }

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

    class func saveImage(_ image: UIImage?,
                         name: String,
                         page: Int = 1,
                         userId: String? = SIDServiceHelper.userId,
                         queue: DispatchQueue = DispatchQueue.global(qos: .default),
                         completion: ((ImageManagerSaveError?) -> Void)?) {

        func complete(_ error: ImageManagerSaveError?) {
            DispatchQueue.main.async {
                completion?(error)
            }
        }

        queue.async {
            guard let image = image else {
                complete(ImageManagerSaveError.imageIsMissing)
                return
            }

            guard let imageData = image.pngData() else {
                complete(ImageManagerSaveError.dataConversionError)
                return
            }

            guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else {
                complete(ImageManagerSaveError.documentPathError)
                return
            }

            self.deleteImage(name: name, page: page, userId: userId, queue: queue) { success in
                var writeData = imageData
                if SIDSettings.instance.cryptSettings.isImageCryptEnabled {
                    writeData = SIDCryptoManager.instance.encrypt(imageData)
                }

                do {
                    try writeData.write(to: imageURL)
                    complete(nil)
                } catch {
                    complete(ImageManagerSaveError.writeError)
                }
            }
        }
    }

    class func getImage(name: String,
                        page: Int = 1,
                        userId: String? = SIDServiceHelper.userId,
                        queue: DispatchQueue = DispatchQueue.global(qos: .default),
                        completion: @escaping (UIImage?, ImageManagerGetError?) -> Void) {

        func complete(image: UIImage?, error: ImageManagerGetError?) {
            DispatchQueue.main.async {
                completion(image, error)
            }
        }

        queue.async {
            guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else {
                complete(image: nil, error: ImageManagerGetError.documentIsPathWrong)
                return
            }
            
            guard fileExists(imageURL) else {
                complete(image: nil, error: ImageManagerGetError.imageNotExist)
                return
            }
            
            guard let imageData = FileManager.default.contents(atPath: imageURL.path) else {
                complete(image: nil, error: ImageManagerGetError.dataConversionError)
                return
            }
            
            var readData = imageData
            if SIDSettings.instance.cryptSettings.isImageCryptEnabled {
                guard let encryptedData: Data = SIDCryptoManager.instance.decrypt(data: imageData) else {
                    complete(image: nil, error: ImageManagerGetError.decryptionError)
                    return
                }
                
                readData = encryptedData
            }
            
            if let image = UIImage(data: readData) {
                complete(image: image, error: nil)
            } else {
                complete(image: nil, error: ImageManagerGetError.dataReadError)
            }
        }
    }

    class func deleteImage(name: String,
                           page: Int = 1,
                           userId: String? = SIDServiceHelper.userId,
                           queue: DispatchQueue = DispatchQueue.global(qos: .default),
                           completion: ((Bool) -> Void)? = nil) {

        func complete(result: Bool) {
            DispatchQueue.main.async {
                completion?(result)
            }
        }

        queue.async {
            guard let imageURL = self.imageURL(name: name, page: page, userId: userId) else {
                complete(result: false)
                return
            }

            do {
                try FileManager.default.removeItem(at: imageURL)
                complete(result: true)
            } catch {
                complete(result: false)
            }
        }
    }
}
