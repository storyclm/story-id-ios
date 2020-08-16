//
//  ImagePickerController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class ImagePickerController: NSObject {

    private var onDeleteImage: (() -> Void)?
    private var completion: ((UIImage?) -> Void)?
    private var viewController: UIViewController?
    private var isDeleteAvailable: Bool = false

    var picker = UIImagePickerController()

    override init() {
        super.init()
    }

    func pickImage(from viewController: UIViewController,
                   isDeleteAvailable: Bool = false,
                   onDeleteImage: @escaping () -> Void,
                   completion: @escaping (UIImage?) -> Void) {

        self.isDeleteAvailable = isDeleteAvailable
        self.onDeleteImage = onDeleteImage
        self.completion = completion
        self.viewController = viewController

        self.showSoucePicker()
    }

    private func showSoucePicker() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "global_camera".loco, style: UIAlertAction.Style.default, handler: { [unowned self] _ in
                self.openCamera()
            }))
        }

        alert.addAction(UIAlertAction(title: "global_gallery".loco, style: UIAlertAction.Style.default, handler: { [unowned self] _ in
            self.openGallery()
        }))

        if isDeleteAvailable {
            alert.addAction(UIAlertAction(title: "global_delete".loco, style: UIAlertAction.Style.destructive, handler: { [unowned self] _ in
                self.deleteImage()
            }))
        }

        alert.addAction(UIAlertAction(title: "global_close".loco, style: UIAlertAction.Style.cancel))
        alert.popoverPresentationController?.sourceView = self.viewController?.view

        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: - Completion

    func done(with image: UIImage?) {
        completion?(image)
        self.viewController = nil
        self.completion = nil
    }

    // MARK: - Actions

    private func openCamera() {
        self.showPicker(with: UIImagePickerController.SourceType.camera)
    }

    private func openGallery() {
        self.showPicker(with: UIImagePickerController.SourceType.photoLibrary)
    }

    private func deleteImage() {
        self.onDeleteImage?()
    }

    // MARK: _ Image picker

    private func showPicker(with sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.viewController?.present(picker, animated: true, completion: nil)
    }
}

extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

        self.done(with: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else {
            self.done(with: nil)
            return
        }

        self.done(with: image)
    }
}
