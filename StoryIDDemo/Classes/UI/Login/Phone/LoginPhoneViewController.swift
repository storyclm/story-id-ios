//
//  LoginPhoneViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class LoginPhoneViewController: UIViewController {

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
        // TODO: call api and show sms view
        self.showLoginSmsController()
    }

    @objc private func tapGestureAction() {
        self.loginPhoneView.textField.resignFirstResponder()
    }

    // MARK: - Controller

    private func showLoginSmsController() {
        let loginSMSViewController = LoginSMSViewController()
        self.navigationController?.pushViewController(loginSMSViewController, animated: true)
        
    }
    
}
