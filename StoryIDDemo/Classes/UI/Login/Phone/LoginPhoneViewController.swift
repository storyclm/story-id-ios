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

        let timer = SmsTimerService.instance
        if timer.isPhoneEqual(phone), timer.isTimerActive {
            self.showOkAlert(title: "", message: self.resendTimerText(timer.seconds))
            return
        }

        self.showLoader()

        AuthManager.instance.verifyCode(phone: phone) { sign, error in
            self.hideLoader()

            if let error = error {
                self.showErrorAlert(error)
            } else if let sign = sign {
                timer.startTimer(phone: phone)
                self.showLoginSmsController(with: sign, phone: phone)
            }
        }
    }

    @objc private func tapGestureAction() {
        self.loginPhoneView.textField.resignFirstResponder()
    }

    // MARK: - Helpers

    func resendTimerText(_ seconds: Int) -> String? {
        var components = DateComponents()
        components.second = seconds

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short

        let timeText = formatter.string(from: components)

        return "login_phone_resend_alert_text".loco + "\n" + (timeText ?? "")
    }

    // MARK: - Controller

    private func showLoginSmsController(with signature: SIDPasswordlessSignature, phone: String) {
        AppRouter.instance.showEnterSms(from: self, signature: signature, phone: phone)
    }
}
