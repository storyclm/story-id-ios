//
//  PincodeService.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Valet

final class PincodeService {

    private let kPincode = "pincode"

    private let valet: Valet

    static let instance = PincodeService()

    private init() {
        let id = Identifier(nonEmpty: "StoryID")!
        self.valet = Valet.valet(with: id, accessibility: Accessibility.whenUnlockedThisDeviceOnly)
    }

    var pincode: String? {
        get { valet.string(forKey: kPincode) }
        set {
            if let value = newValue {
                valet.set(string: value, forKey: kPincode)
            } else {
                valet.removeObject(forKey: kPincode)
            }
        }
    }

    var isPincodeSet: Bool { valet.containsObject(forKey: kPincode) }

    // MARK: -

    private let kUserDefaultsPincode = "PincodeService.Pincode.Key"
    var isLogined: Bool {
        get { UserDefaults.standard.bool(forKey: kUserDefaultsPincode) }
        set { UserDefaults.standard.set(newValue, forKey: kUserDefaultsPincode) }
    }
}
