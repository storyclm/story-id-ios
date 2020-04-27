//
//  LoginPhoneView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class LoginPhoneView: BaseView {

    private let titleLabel = UILabel()
    let textField = PhoneTextField()
    let separatorView = UIView()
    let getCodeButton = UIButton(type: UIButton.ButtonType.custom)
    let tapGesture = UITapGestureRecognizer()
    
    override func setup() {
        super.setup()

        self.addGestureRecognizer(tapGesture)

        self.backgroundColor = UIColor.idWhite

        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.numberOfLines = 1
        self.titleLabel.textColor = UIColor.idBlack
        self.titleLabel.textAlignment = NSTextAlignment.left
        self.titleLabel.font = UIFont.systemFont(ofSize: 34.0, weight: UIFont.Weight.bold)
        self.titleLabel.text = "login_phone_title".loco
        self.addSubview(self.titleLabel)

        self.textField.backgroundColor = UIColor.clear
        self.textField.placeholder = "login_phone_placeholder".loco
        self.textField.keyboardType = UIKeyboardType.phonePad
        self.textField.autocapitalizationType = UITextAutocapitalizationType.none
        self.textField.updateValidState = {[weak self] text, isValid in
            self?.getCodeButton.isEnabled = isValid
            if isValid {
                self?.textField.resignFirstResponder()
            }
        }
        self.textField.isWrongInput = true
        _ = self.textField.checkValidation()
        self.addSubview(self.textField)

        self.separatorView.backgroundColor = UIColor.idBlack
        self.separatorView.alpha = 0.5
        self.addSubview(self.separatorView)

        let buttonBackgroundColor = UIColor.idRed
        self.getCodeButton.setBackgroundImage(UIImage.idCreate(from: buttonBackgroundColor), for: UIControl.State.normal)
        self.getCodeButton.setBackgroundImage(UIImage.idCreate(from: buttonBackgroundColor.withAlphaComponent(0.75)), for: UIControl.State.disabled)

        let buttonTextColor = UIColor.idWhite
        self.getCodeButton.setTitleColor(buttonTextColor, for: UIControl.State.normal)
        self.getCodeButton.setTitleColor(buttonTextColor.withAlphaComponent(0.75), for: UIControl.State.disabled)
        self.getCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        self.getCodeButton.layer.cornerRadius = 4.0
        self.getCodeButton.layer.masksToBounds = true
        self.getCodeButton.setTitle("login_phone_getCode_button".loco, for: UIControl.State.normal)
        self.addSubview(self.getCodeButton)

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.getCodeButton.translatesAutoresizingMaskIntoConstraints = false

        self.setupConstraints()
    }

    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIViewController.idSafeAreaInsets.top + 22.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),

            self.getCodeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.getCodeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64.0),
            self.getCodeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64.0),
            self.getCodeButton.heightAnchor.constraint(equalToConstant: 56.0),

            self.separatorView.bottomAnchor.constraint(equalTo: self.getCodeButton.topAnchor, constant: -55),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),

            self.textField.bottomAnchor.constraint(equalTo: self.separatorView.topAnchor, constant: -5.0),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            self.textField.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
}
