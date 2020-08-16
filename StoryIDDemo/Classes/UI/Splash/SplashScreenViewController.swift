//
//  SplashScreenViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class SplashScreenViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.showAuthorization()
    }

    // MARK: - Show

    func showAuthorization() {
        AppRouter.instance.showAuthorization(from: self) { vc, _ in
            SIDPersonalDataService.instance.synchronize()
            AppRouter.instance.showProfile(from: vc)
        }
    }

    // MARK: -

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
