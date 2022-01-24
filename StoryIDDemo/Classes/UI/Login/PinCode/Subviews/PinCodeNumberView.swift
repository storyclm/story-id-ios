//
//  PinCodeNumberView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class PinCodeNumberView: UIButton {

    var onClickAction: ((Int) -> Void)?

    private let numberLabel = UILabel()
    private let number: Int

    init(with number: Int) {
        self.number = number
        super.init(frame: CGRect.zero)

        self.setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = iBorderColor.cgColor

        self.numberLabel.backgroundColor = UIColor.clear
        self.numberLabel.numberOfLines = 1
        self.numberLabel.textAlignment = NSTextAlignment.center
        self.numberLabel.textColor = iTextColor
        self.numberLabel.font = UIFont.systemFont(ofSize: 28.0, weight: UIFont.Weight.regular)
        self.numberLabel.text = "\(number)"
        self.addSubview(self.numberLabel)

        self.addTarget(self, action: #selector(buttonAction(_:)), for: UIControl.Event.touchUpInside)

        self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.setupConstraints()
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2.0
    }

    // MARK: - Override

    override var isHighlighted: Bool {
        didSet { self.updateViewAppearance() }
    }

    override var isEnabled: Bool {
        didSet { self.updateViewAppearance() }
    }

    // MARK: - Appearance

    private var iBorderColor: UIColor { UIColor(red: 0.87, green: 0.04, blue: 0.15, alpha: 0.4) }
    private var iTextColor: UIColor { UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0) }

    private func updateViewAppearance() {
        if isHighlighted {
            self.numberLabel.textColor = UIColor.idBlack
            self.backgroundColor = self.iBorderColor.withAlphaComponent(0.75)
        } else if isEnabled == false {
            self.numberLabel.textColor = self.iTextColor.withAlphaComponent(0.75)
            self.backgroundColor = UIColor.clear
        } else {
            self.numberLabel.textColor = self.iTextColor
            self.backgroundColor = UIColor.clear
        }
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.numberLabel.heightAnchor.constraint(equalToConstant: 56.0),
            self.numberLabel.widthAnchor.constraint(equalToConstant: 56.0),
            self.numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func buttonAction(_ sender: UIButton) {
        self.onClickAction?(self.number)
    }
}
