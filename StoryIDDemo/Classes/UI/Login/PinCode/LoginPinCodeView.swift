//
//  LoginPinCodeView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class LoginPinCodeView: BaseView {

    private let logoImageView = UIImageView(image: UIImage(named: "img_launchScreen_title"))
    private let errorLabel = UILabel()

    let pinCodePreviewView = PinCodePreviewView()
    let pinCodeEnterView = PinCodeEnterView()
    let bottomButton = UIButton()

    override func setup() {
        super.setup()

        self.backgroundColor = UIColor.idWhite

        self.logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.logoImageView.tintColor = UIColor.idRed

        self.errorLabel.alpha = 0.0
        self.errorLabel.textAlignment = NSTextAlignment.center
        self.errorLabel.textColor = UIColor.idRed
        self.errorLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        self.errorLabel.text = "login_pincode_error_wrong".loco

        self.bottomButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.bottomButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
        let textColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        self.bottomButton.setTitleColor(textColor, for: UIControl.State.normal)
        self.bottomButton.setTitleColor(textColor.withAlphaComponent(0.75), for: UIControl.State.highlighted)

        self.addSubview(self.logoImageView)
        self.addSubview(self.pinCodePreviewView)
        self.addSubview(self.errorLabel)
        self.addSubview(self.pinCodeEnterView)
        self.addSubview(self.bottomButton)

        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.pinCodePreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pinCodeEnterView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomButton.translatesAutoresizingMaskIntoConstraints = false

        self.setupConstraints()
    }

    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: UIViewController.idSafeAreaInsets.top + 15.0),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 57.0),
            self.logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            self.pinCodePreviewView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 50.0),
            self.pinCodePreviewView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.pinCodePreviewView.heightAnchor.constraint(equalToConstant: 50.0),
            self.pinCodePreviewView.widthAnchor.constraint(equalTo: self.widthAnchor),

            self.errorLabel.topAnchor.constraint(equalTo: self.pinCodePreviewView.bottomAnchor, constant: 15.0),
            self.errorLabel.heightAnchor.constraint(equalToConstant: 15.0),
            self.errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.pinCodeEnterView.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor, constant: 15.0),
            self.pinCodeEnterView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.pinCodeEnterView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.pinCodeEnterView.heightAnchor.constraint(equalToConstant: 298.0),

            self.bottomButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50.0),
            self.bottomButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50.0),
            self.bottomButton.topAnchor.constraint(equalTo: self.pinCodeEnterView.bottomAnchor, constant: 40.0),
            self.bottomButton.heightAnchor.constraint(equalToConstant: 23.0),
        ])
    }

    // MARK: - Error message

    func showErrorMessage() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.errorLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 5.0, options: [], animations: { [weak self] in
                self?.errorLabel.alpha = 0.0
            }, completion: nil)
        }
    }
}
