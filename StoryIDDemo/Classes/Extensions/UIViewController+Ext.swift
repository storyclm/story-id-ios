//
//  UIViewController+Ext.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

// MARK: - NavigationType

enum NavigationType {
    case push
    case modal
    case modalFade
}

extension UIViewController {

    static var idSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        return UIEdgeInsets.zero
    }

    class func show(from: UIViewController, isModalFade: Bool, navigationController: UINavigationController, animated: Bool = true) {
        if isModalFade {
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .crossDissolve

            from.present(navigationController, animated: animated) {
                guard let window = UIApplication.shared.keyWindow else { return }

                window.rootViewController?.dismiss(animated: false, completion: {
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                })
            }
        } else {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            from.present(navigationController, animated: animated)
        }
    }

    class func show(from: UIViewController, navigationType: NavigationType, vc: UIViewController, animated: Bool = true) {
        switch navigationType {
        case .push:
            from.navigationController?.pushViewController(vc, animated: animated)
        case .modal:
            vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            from.present(vc, animated: animated)
        case .modalFade:
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve

            from.present(vc, animated: animated) {
                guard let window = UIApplication.shared.keyWindow else { return }

                window.rootViewController?.dismiss(animated: false, completion: {
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                })
            }
        }
    }

    class func topVC(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topVC(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topVC(base: selected)

        } else if let presented = base?.presentedViewController {
            return topVC(base: presented)
        }
        return base
    }
}

// MARK: - Alerts

extension UIViewController {

    static func showOkAlert(on viewController: UIViewController, title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "global_ok".loco, style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

    static func showErrorAlert(on viewController: UIViewController, error: Error) {
        Self.showOkAlert(on: viewController, title: "global_error".loco, message: error.localizedDescription)
    }

    func showErrorAlert(_ error: Error) {
        Self.showErrorAlert(on: self, error: error)
    }

    func showOkAlert(title: String?, message: String?) {
        Self.showOkAlert(on: self, title: title, message: message)
    }
}
