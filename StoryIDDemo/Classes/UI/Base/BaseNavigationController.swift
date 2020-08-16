//
//  BaseNavigationController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UIImage(named: "img_navbar_background")
        self.navigationBar.setBackgroundImage(logo, for: UIBarMetrics.default)
    }
}
