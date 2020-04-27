//
//  LoginSMSViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class LoginSMSViewController: UIViewController {

    private let loginSMSView = LoginSMSView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginSMSView.frame = self.view.bounds
        self.view.addSubview(loginSMSView)

        self.loginSMSView.delegate = self
        self.loginSMSView.resendCodeButton.addTarget(self, action: #selector(resendCodeAction), for: UIControl.Event.touchUpInside)
        self.loginSMSView.tapGesture.addTarget(self, action: #selector(tapGestureAction))
    }

    // MARK: - Actions

    @objc private func resendCodeAction() {

    }

    @objc private func tapGestureAction() {
        self.loginSMSView.textField.resignFirstResponder()
    }

    // MARK: - Pincode

    private func showPincodeAlert() {
        let pincodeAlert = UIAlertController(title: "login_sms_pincode_alert_title".loco, message: "login_sms_pincode_alert_subtitle".loco, preferredStyle: UIAlertController.Style.alert)
        pincodeAlert.addAction(UIAlertAction(title: "global_no".loco, style: UIAlertAction.Style.cancel, handler: { [unowned self] _ in
            self.showProfileController()
        }))
        pincodeAlert.addAction(UIAlertAction(title: "global_yes".loco, style: UIAlertAction.Style.default, handler: { [unowned self] _ in
            self.showPincodeController()
        }))

        self.present(pincodeAlert, animated: true)
    }

    private func showProfileController() {
        PincodeService.instance?.isLogined = true
        
        AppRouter.instance.showProfile(from: self)
    }

    private func showPincodeController() {
        PincodeService.instance?.isLogined = true

        AppRouter.instance.showEnterCode(from: self, state: AuthCodeState.new) {[weak self] (_, success) in
            guard let self = self else { return }
            if success {
                AppRouter.instance.showProfile(from: self)
            }
        }
    }
}

extension LoginSMSViewController: LoginSMSViewDelegate {

    func loginSmsView(_ view: LoginSMSView, didEnterCode code: String?) {
//        guard let code = code?.notEmptyValue else { return }

        view.textField.resignFirstResponder()
        // TODO: Call api!
        self.showPincodeAlert()
    }
}
