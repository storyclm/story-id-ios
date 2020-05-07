//
//  BaseViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private let loader = UILoaderView()

    func showLoader() {
        self.loader.frame = self.view.bounds
        self.view.addSubview(loader)
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.loader.removeFromSuperview()
        }
    }
}

private class UILoaderView: UIView {

    let contentView = UIView()
    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear

        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.80)
        self.contentView.layer.masksToBounds = true
        self.addSubview(self.contentView)

        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.startAnimating()
        self.contentView.addSubview(self.activityIndicatorView)

        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.frame = {
            var rect = CGRect.zero
            rect.size = CGSize(width: 100.0, height: 100.0)
            rect.origin.x = (self.frame.width - rect.width) * 0.5
            rect.origin.y = (self.frame.height - rect.height) * 0.5
            return rect
        }()
        self.contentView.layer.cornerRadius = 10.0

        self.activityIndicatorView.frame = {
            var rect = self.activityIndicatorView.bounds
            rect.origin.x = (self.contentView.frame.width - rect.width) * 0.5
            rect.origin.y = (self.contentView.frame.height - rect.height) * 0.5
            return rect.integral
        }()
    }

}
