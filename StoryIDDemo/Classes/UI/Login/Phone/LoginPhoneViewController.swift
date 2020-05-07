//
//  LoginPhoneViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class LoginPhoneViewController: BaseViewController {

    private let loginPhoneView = LoginPhoneView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginPhoneView.frame = self.view.bounds
        self.view.addSubview(loginPhoneView)

        self.loginPhoneView.getCodeButton.addTarget(self, action: #selector(sendCodeAction), for: UIControl.Event.touchUpInside)
        self.loginPhoneView.tapGesture.addTarget(self, action: #selector(tapGestureAction))
    }

    // MARK: - Actions

    @objc private func sendCodeAction() {
        guard var phone = self.loginPhoneView.textField.value else { return }
        phone = "7\(phone)"

        self.showLoader()

        AuthManager.instance.verifyCode(phone: phone) { (sign, error) in
            self.hideLoader()
            
            if let error = error {
                self.showErrorAlert(error)
            } else if let sign = sign {
                self.showLoginSmsController(with: sign, phone: phone)
            }
        }
    }

    @objc private func tapGestureAction() {
        self.loginPhoneView.textField.resignFirstResponder()
    }

    // MARK: - Controller

    private func showLoginSmsController(with signature: SIDPasswordlessSignature, phone: String) {
        let loginSMSViewController = LoginSMSViewController()
        loginSMSViewController.signature = signature
        loginSMSViewController.phone = phone
        self.navigationController?.pushViewController(loginSMSViewController, animated: true)
        
    }
    
}
