//
//  LoginSMSView.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

protocol LoginSMSViewDelegate: class {
    func loginSmsView(_ view: LoginSMSView, didEnterCode code: String?)
}

final class LoginSMSView: BaseView {

    weak var delegate: LoginSMSViewDelegate?

    private let titleLabel = UILabel()
    let textField = SMSTextField()
    let separatorView = UIView()
    let tapGesture = UITapGestureRecognizer()

    let tapResendGesture = UITapGestureRecognizer()
    let resendLabel = UILabel()

    override func setup() {
        super.setup()

        self.addGestureRecognizer(tapGesture)

        self.backgroundColor = UIColor.idWhite

        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.numberOfLines = 1
        self.titleLabel.textColor = UIColor.idBlack
        self.titleLabel.textAlignment = NSTextAlignment.left
        self.titleLabel.font = UIFont.systemFont(ofSize: 34.0, weight: UIFont.Weight.bold)
        self.titleLabel.text = "login_sms_title".loco
        self.addSubview(self.titleLabel)

        self.textField.backgroundColor = UIColor.clear
        self.textField.textAlignment = NSTextAlignment.center
        self.textField.placeholder = "login_sms_placeholder".loco
        self.textField.keyboardType = UIKeyboardType.numberPad
        self.textField.autocapitalizationType = UITextAutocapitalizationType.none
        self.textField.updateValidState = {[unowned self] sms, isValid in
            if isValid {
                self.delegate?.loginSmsView(self, didEnterCode: sms)
            }
        }
        self.textField.isWrongInput = true
        _ = self.textField.checkValidation()
        self.addSubview(self.textField)

        self.separatorView.backgroundColor = UIColor.idBlack
        self.separatorView.alpha = 0.5
        self.addSubview(self.separatorView)

        self.resendLabel.isUserInteractionEnabled = true
        self.resendLabel.numberOfLines = 0
        self.addSubview(self.resendLabel)

        self.resendLabel.addGestureRecognizer(tapResendGesture)

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.resendLabel.translatesAutoresizingMaskIntoConstraints = false

        self.setupConstraints()
    }

    func updateResend(text: String?, isEnabled: Bool) {
        self.tapResendGesture.isEnabled = isEnabled

        guard let text = text else {
            self.resendLabel.text = ""
            return
        }

        var color = UIColor.idBlack
        if isEnabled == false {
            color = UIColor.gray
        }

        let resendText = AttributedStringBuilder(font: UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.semibold),
                                                 color: color,
                                                 alignment: NSTextAlignment.center,
                                                 kern: 0.0)
            .add(text)
            .changeParagraphStyle(minimumLineHeight: 13.0)
            .result()

        self.resendLabel.attributedText = resendText
    }

    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIViewController.idSafeAreaInsets.top + 22.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),

            self.resendLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.resendLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64.0),
            self.resendLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -64.0),
            self.resendLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40.0),

            self.separatorView.bottomAnchor.constraint(equalTo: self.resendLabel.topAnchor, constant: -55),
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
