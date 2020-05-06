//
//  SIDPasswordlessSignature.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public struct SIDPasswordlessSignature: Codable {
    var expiration: String
    var signature: String
}
