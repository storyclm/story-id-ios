//
//  AppPropertiesManager.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

final class AppPropertiesManager {

    private var plistData: [String: Any]?

    static let instance = AppPropertiesManager()

    private init() {
        self.plistData = readPropertyList()
    }

    // MARK: - Vars

    var apiEndpoint: String? { plistData?["API_ID_ENDPOINT"] as? String }
    var apiConfigUrl: String? { plistData?["API_ID_CONFIG_URL"] as? String }

    var client: String? { plistData?["CLIENT_ID"] as? String }
    var secret: String? { plistData?["CLIENT_SECRET"] as? String }

    var cryptoPassword: String? { plistData?["CRYPTO_PASSWORD"] as? String }
    var cryptoSalt: String? { plistData?["CRYPTO_SALT"] as? String }

    // MARK: - Load property

    private func readPropertyList() -> [String: Any]? {
        guard let plistPath: String = Bundle.main.path(forResource: "AppProperties", ofType: "plist") else { return nil }
        guard let plistXML = FileManager.default.contents(atPath: plistPath) else { return nil }

        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        do {
            return try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String: Any]
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
            return nil
        }
    }
}
