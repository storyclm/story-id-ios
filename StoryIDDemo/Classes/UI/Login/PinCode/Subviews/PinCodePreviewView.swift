//
//  PinCodePreviewView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class PinCodePreviewView: BaseView {

    let enterCodeLabel = UILabel()
    private let stackView = UIStackView()
    private var dotViews: [PinCodeDotView] = []

    private(set) var activeCount = 0

    override func setup() {
        super.setup()

        enterCodeLabel.backgroundColor = UIColor.clear
        enterCodeLabel.numberOfLines = 1
        enterCodeLabel.textAlignment = NSTextAlignment.center
        enterCodeLabel.textColor = UIColor.idBlack
        enterCodeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
        self.addSubview(enterCodeLabel)

        self.stackView.spacing = 15.0
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.distribution = UIStackView.Distribution.fill
        self.stackView.axis = NSLayoutConstraint.Axis.horizontal
        self.addSubview(self.stackView)

        for _ in 0 ..< 4 {
            let view = PinCodeDotView()
            dotViews.append(view)
            self.stackView.addArrangedSubview(view)
        }

        self.enterCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        self.setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            enterCodeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            enterCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            enterCodeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            enterCodeLabel.heightAnchor.constraint(equalToConstant: 16.0),

            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: enterCodeLabel.bottomAnchor, constant: 12.0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 12.0),
        ])
    }

    // MARK: - Dots

    func setActivityCount(_ count: Int) {
        var count = count
        if count < 0 {
            count = 0
        } else if count > 4 {
            count = 0
        }
        self.activeCount = count
        self.updateDotActivity()
    }

    private func updateDotActivity() {
        for (idx, dotView) in self.dotViews.enumerated() {
            dotView.isActive = (idx + 1) <= self.activeCount
        }
    }
}
