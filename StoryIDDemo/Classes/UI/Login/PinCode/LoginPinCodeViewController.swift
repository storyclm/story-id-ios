//
//  LoginPinCodeViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

// MARK: - AuthCodeState

enum AuthCodeState: Equatable {
    case new
    case repeatCode(String)
    case check
    case reset

    var displayedTitle: String {
        switch self {
        case .new, .check: return "login_pincode_enter_code".loco
        case .repeatCode: return "login_pincode_repeat_code".loco
        case .reset: return "login_pincode_enter_code".loco
        }
    }

    var displayedAction: String {
        return self.isCancelable ? "global_cancel".loco : "login_pincode_forgot_button".loco
    }

    var isCancelable: Bool {
        switch self {
        case .new, .repeatCode, .reset: return true
        case .check: return false
        }
    }

    static func == (lhs: AuthCodeState, rhs: AuthCodeState) -> Bool {
        switch (lhs, rhs) {
        case (.new, .new): return true
        case (.check, .check): return true
        case (.repeatCode, .repeatCode): return true
        case (.reset, .reset): return true
        default: return false
        }
    }
}

// MARK: - LoginPinCodeViewController

final class LoginPinCodeViewController: UIViewController {

    private let loginPincodeView = LoginPinCodeView()

    var completion: ((UIViewController, Bool) -> Void)?

    var state = AuthCodeState.new {
        didSet { self.updateAppearance() }
    }

    var code = "" {
        didSet {
            if code.count > 4 {
                code = oldValue
            } else {
                self.loginPincodeView.pinCodePreviewView.setActivityCount(code.count)

                if oldValue.count == 3, code.count == 4 {
                    self.validateCode()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginPincodeView.frame = self.view.bounds
        self.view.addSubview(self.loginPincodeView)

        self.loginPincodeView.pinCodeEnterView.onNumberEnter = { [unowned self] number in
            self.code += "\(number)"
        }
        self.loginPincodeView.pinCodeEnterView.deleteButton.addTarget(self, action: #selector(deleteCharAction(_:)), for: UIControl.Event.touchUpInside)
        self.loginPincodeView.bottomButton.addTarget(self, action: #selector(bottomButtonAction(_:)), for: UIControl.Event.touchUpInside)

        self.updateAppearance()
    }

    // MARK: - Code

    private func validateCode() {
        let checkCode: String?
        switch state {
        case .new:
            checkCode = self.code
        case .check, .reset:
            checkCode = PincodeService.instance.pincode
        case let .repeatCode(repeatCode):
            checkCode = repeatCode
        }

        if let savedPincode = checkCode {
            if savedPincode == self.code {
                self.successAction()
            } else {
                self.code = ""
                self.loginPincodeView.showErrorMessage()
            }
        } else {
            self.showValidationErrorAlert()
        }
    }

    private func showValidationErrorAlert() {
        let alert = UIAlertController(title: nil, message: "login_pincode_error_empty".loco, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "global_ok".loco, style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }

    // MARK: - Actions

    @objc private func deleteCharAction(_ sender: UIButton) {
        if code.isEmpty == false {
            code.removeLast()
        }
    }

    @objc private func bottomButtonAction(_ sender: UIButton) {
        if state.isCancelable {
            self.cancelAction()
        } else {
            self.forgotAction()
        }
    }

    private func forgotAction() {
        AppRouter.instance.showEnterPhone(from: self, reason: nil)
    }

    private func cancelAction() {
        completion?(self, false)
    }

    private func successAction() {
        if state == .new {
            AppRouter.instance.showEnterCode(from: self, state: AuthCodeState.repeatCode(self.code), completion: completion)
            self.code = ""
        } else {
            if case let AuthCodeState.repeatCode(repeatCode) = self.state {
                PincodeService.instance.pincode = repeatCode
            } else if case AuthCodeState.reset = self.state {
                PincodeService.instance.pincode = nil
            }
            completion?(self, true)
        }
    }

    // MARK: - Appearance

    private func updateAppearance() {
        self.loginPincodeView.pinCodePreviewView.enterCodeLabel.text = self.state.displayedTitle
        self.loginPincodeView.bottomButton.setTitle(self.state.displayedAction, for: UIControl.State.normal)
    }
}
