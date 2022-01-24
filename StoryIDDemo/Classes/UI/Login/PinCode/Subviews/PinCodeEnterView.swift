//
//  PinCodeEnterView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class PinCodeEnterView: BaseView {

    var onNumberEnter: ((Int) -> Void)?

    private let mainStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()
    private let thirdStackView = UIStackView()
    private let fourthStackView = UIStackView()

    private var numberViews: [PinCodeNumberView] = []
    let deleteButton = UIButton(type: UIButton.ButtonType.custom)
    let secureButton = UIButton(type: UIButton.ButtonType.custom)

    override func setup() {
        super.setup()

        self.deleteButton.setTitle("login_pincode_delete_button".loco, for: UIControl.State.normal)
        let deletTextColor = UIColor(red: 0.75, green: 0.06, blue: 0.14, alpha: 0.6)
        self.deleteButton.setTitleColor(deletTextColor, for: UIControl.State.normal)
        self.deleteButton.setTitleColor(deletTextColor.withAlphaComponent(0.75), for: UIControl.State.highlighted)
        self.deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)

        self.mainStackView.axis = NSLayoutConstraint.Axis.vertical
        self.mainStackView.alignment = UIStackView.Alignment.center
        self.mainStackView.distribution = UIStackView.Distribution.equalSpacing
        self.mainStackView.spacing = 23.0

        self.mainStackView.addArrangedSubview(self.firstStackView)
        self.mainStackView.addArrangedSubview(self.secondStackView)
        self.mainStackView.addArrangedSubview(self.thirdStackView)
        self.mainStackView.addArrangedSubview(self.fourthStackView)

        [self.firstStackView, self.secondStackView, self.thirdStackView, self.fourthStackView].forEach { stackView in
            stackView.axis = NSLayoutConstraint.Axis.horizontal
            stackView.distribution = UIStackView.Distribution.equalSpacing
            stackView.spacing = 33.0
        }

        self.fillNumbers(from: 1, to: 3, at: self.firstStackView)
        self.fillNumbers(from: 4, to: 6, at: self.secondStackView)
        self.fillNumbers(from: 7, to: 9, at: self.thirdStackView)
        self.fillFourthStackView()

        self.addSubview(mainStackView)

        self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.firstStackView.translatesAutoresizingMaskIntoConstraints = false
        self.secondStackView.translatesAutoresizingMaskIntoConstraints = false
        self.thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        self.fourthStackView.translatesAutoresizingMaskIntoConstraints = false

        self.setupConstraints()
    }

    private func fillNumbers(from: Int, to: Int, at: UIStackView) {
        for i in from ... to {
            let numberView = self.numberView(with: i)
            at.addArrangedSubview(numberView)
        }
    }

    private func fillFourthStackView() {
        self.fourthStackView.addArrangedSubview(self.secureButton)
        self.fourthStackView.addArrangedSubview(self.numberView(with: 0))
        self.fourthStackView.addArrangedSubview(self.deleteButton)
    }

    private func numberView(with number: Int) -> PinCodeNumberView {
        let numberView = PinCodeNumberView(with: number)
        numberView.onClickAction = { number in
            self.onNumberEnter?(number)
        }
        numberViews.append(numberView)
        return numberView
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.mainStackView.topAnchor.constraint(equalTo: self.topAnchor),

            self.secureButton.heightAnchor.constraint(equalToConstant: 56.0),
            self.secureButton.widthAnchor.constraint(equalToConstant: 56.0),

            self.firstStackView.heightAnchor.constraint(equalToConstant: 57.0),
            self.secondStackView.heightAnchor.constraint(equalToConstant: 57.0),
            self.thirdStackView.heightAnchor.constraint(equalToConstant: 57.0),
            self.fourthStackView.heightAnchor.constraint(equalToConstant: 57.0),
        ])
    }
}
