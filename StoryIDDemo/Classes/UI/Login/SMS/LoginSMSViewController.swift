//
//  LoginSMSViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class LoginSMSViewController: BaseViewController {

    private let loginSMSView = LoginSMSView()

    var signature: SIDPasswordlessSignature?
    var phone: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        loginSMSView.frame = self.view.bounds
        self.view.addSubview(loginSMSView)

        self.loginSMSView.delegate = self
        self.loginSMSView.tapResendGesture.addTarget(self, action: #selector(resendCodeAction))
        self.loginSMSView.tapGesture.addTarget(self, action: #selector(tapGestureAction))

        self.loginSMSView.textField.becomeFirstResponder()

        SmsTimerService.instance.delegate = self
        SmsTimerService.instance.callFireDelegate()
    }

    // MARK: - Actions

    @objc private func resendCodeAction() {
        self.loginSMSView.textField.resignFirstResponder()

        guard let phone = self.phone else { return }

        self.showLoader()

        AuthManager.instance.verifyCode(phone: phone) {[weak self] (sign, error) in
            self?.hideLoader()

            if let error = error {
                self?.showErrorAlert(error)
            } else if let sign = sign {
                SmsTimerService.instance.startTimer(phone: phone)
                self?.signature = sign
                self?.loginSMSView.textField.becomeFirstResponder()
            }
        }
    }

    @objc private func tapGestureAction() {
        self.loginSMSView.textField.resignFirstResponder()
    }

    // MARK: - Pincode

    private func showPincodeAlert() {
        SIDPersonalDataService.instance.synchronize()
        
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
        PincodeService.instance.isLogined = true
        
        AppRouter.instance.showProfile(from: self)
    }

    private func showPincodeController() {
        PincodeService.instance.isLogined = true

        AppRouter.instance.showEnterCode(from: self, state: AuthCodeState.new) {[weak self] (vc, success) in
            guard let self = self else { return }
            if success {
                vc.dismiss(animated: true) {
                    AppRouter.instance.showProfile(from: self)
                }
            }
        }
    }
}

extension LoginSMSViewController: LoginSMSViewDelegate {

    func loginSmsView(_ view: LoginSMSView, didEnterCode code: String?) {
        guard let code = code?.notEmptyValue else { return }
        guard let phone = self.phone, let sign = self.signature else { return }

        self.loginSMSView.textField.resignFirstResponder()
        self.showLoader()

        AuthManager.instance.login(signature: sign, phone: phone, code: code) { error in
            self.hideLoader()

            if error != nil {
                self.showOkAlert(title: "", message: "login_sms_error_general".loco)
                self.loginSMSView.textField.text = nil
                self.loginSMSView.textField.becomeFirstResponder()
            } else {
                self.showPincodeAlert()
            }
        }
    }
}

extension LoginSMSViewController: SmsTimerServiceDelegate {

    func timerFired(_ timerService: SmsTimerService, seconds: Int) {
        self.loginSMSView.updateResend(text: self.resendTimerText(seconds), isEnabled: false)
    }

    func timedDone(_ timerService: SmsTimerService) {
        self.loginSMSView.updateResend(text: "login_sms_resent_button".loco, isEnabled: true)
    }

    func resendTimerText(_ seconds: Int) -> String? {
        var components = DateComponents()
        components.second = seconds

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short

        let timeText = formatter.string(from: components)

        return "login_sms_resend".loco + "\n" + (timeText ?? "")
    }
}
