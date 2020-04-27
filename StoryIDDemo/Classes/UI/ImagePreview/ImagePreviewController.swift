//
//  ImagePreviewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation
import SKPhotoBrowser

final class ImagePreviewController {

    private var images: [SKPhoto]?
    private var startIndex = 0
    private var onDeleteAction: ((SKPhotoBrowser, Int) -> Void)?

    func show(images: [UIImage], from viewController: UIViewController, onDeleteAction: ((SKPhotoBrowser, Int) -> Void)?) {
        self.images = images.map { SKPhoto.photoWithImage($0) }
        self.onDeleteAction = onDeleteAction

        self.showBrowser(from: viewController)
    }

    private func showBrowser(from viewController: UIViewController) {
        guard let images = self.images else { return }

        SKPhotoBrowserOptions.displayDeleteButton = true
        SKPhotoBrowserOptions.displayCounterLabel = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = images.isEmpty == false
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false

        let browser = SKPhotoBrowser(photos: images, initialPageIndex: self.startIndex)
        browser.delegate = self

        viewController.present(browser, animated: true)
    }
}

extension ImagePreviewController: SKPhotoBrowserDelegate {

    @objc func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        self.onDeleteAction?(browser, index)
    }

}
