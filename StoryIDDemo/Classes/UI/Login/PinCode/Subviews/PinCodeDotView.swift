//
//  PinCodeDotView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class PinCodeDotView: BaseView {

    var inactiveColor = UIColor.idWhite {
        didSet {
            self.updateActiveState()
        }
    }

    var activeColor = UIColor(red: 0.75, green: 0.06, blue: 0.14, alpha: 1.0) {
        didSet {
            self.updateActiveState()
        }
    }

    var borderColor = UIColor(red: 0.87, green: 0.04, blue: 0.15, alpha: 1.0) {
        didSet {
            self.updateActiveState()
        }
    }

    var isActive = false {
        didSet {
            self.updateActiveState()
        }
    }

    // MARK: - Setup

    override func setup() {
        super.setup()

        self.layer.masksToBounds = true

        self.setupConstraints()
        self.updateActiveState()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2.0
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 12.0),
            self.heightAnchor.constraint(equalToConstant: 12.0),
        ])
    }

    // MARK: - Update active state

    private func updateActiveState() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = self.borderColor.cgColor

        self.backgroundColor = isActive ? self.activeColor : self.inactiveColor
        self.setNeedsLayout()
    }
}
