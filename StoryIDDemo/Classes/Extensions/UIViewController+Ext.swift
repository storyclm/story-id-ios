//
//  UIViewController+Ext.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

enum NavigationType {
    case push, modal, modalFade
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
}
