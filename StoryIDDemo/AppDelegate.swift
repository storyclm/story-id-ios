//
//  AppDelegate.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        }

        self.setupStoryId()
        
        return true
    }

    func setupStoryId() {
        let properties = AppPropertiesManager.instance

        SIDSettings.instance.cryptoPassword = properties.cryptoPassword
        SIDSettings.instance.cryptoSalt = properties.cryptoSalt
        SIDSettings.instance.isRemoveImageAtSync = false
    }
}
