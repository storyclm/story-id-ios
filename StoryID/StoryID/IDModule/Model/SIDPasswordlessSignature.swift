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

public extension SIDPasswordlessSignature {
    var expirationDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"

        if let date = dateFormatter.date(from: self.expiration) {
            return date
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self.expiration)
    }
}
