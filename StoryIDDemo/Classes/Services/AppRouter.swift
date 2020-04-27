//
//  AppRouter.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class AppRouter {

    static let instance = AppRouter()

    private init() {}

    func showAuthorization(from: UIViewController, completion: @escaping (UIViewController, Bool) -> Void) {
        if PincodeService.instance?.isLogined == false {
            AppRouter.instance.showEnterPhone(from: from)
        } else if PincodeService.instance?.isPincodeSet == false {
            completion(from, true)
        } else {
            AppRouter.instance.showEnterCode(from: from, state: AuthCodeState.check, completion: completion)
        }
    }

    func showEnterPhone(from: UIViewController) {

        let loginVC = LoginPhoneViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.setNavigationBarHidden(true, animated: false)

        UIViewController.show(from: from, isModalFade: true, navigationController: navigationController, animated: true)
    }

    func showEnterSms(from: UIViewController, signature: String?, phone: String) {
        let loginSMSViewController = LoginSMSViewController()
        UIViewController.show(from: from, navigationType: NavigationType.push, vc: loginSMSViewController, animated: true)
    }

    func showEnterCode(from: UIViewController, state: AuthCodeState, repeatCode: String? = nil, completion: ((UIViewController, Bool) -> Void)?) {
        let pincodeViewController = LoginPinCodeViewController()
        pincodeViewController.state = state
        pincodeViewController.completion = completion

        if state == .new, state == .check {
            let nvc = UINavigationController(rootViewController: pincodeViewController)
            nvc.setNavigationBarHidden(true, animated: false)
            UIViewController.show(from: from, isModalFade: true, navigationController: nvc, animated: true)
        } else {
            UIViewController.show(from: from, navigationType: NavigationType.modalFade, vc: pincodeViewController, animated: true)
        }
    }

    func showProfile(from: UIViewController) {
        let profileViewController = ProfileMainViewController()
        let navigationController = BaseNavigationController(rootViewController: profileViewController)

        UIViewController.show(from: from, isModalFade: true, navigationController: navigationController, animated: true)
    }
}
