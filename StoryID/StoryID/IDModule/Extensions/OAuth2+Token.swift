//
//  OAuth2+Token.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import p2_OAuth2

extension OAuth2 {

    public func tokenValue<ValueType>(for key: String) -> ValueType? {
        guard let accessToken = self.accessToken, let jwt = jwtDecode(jwtToken: accessToken), let sub = jwt[key] as? ValueType else { return nil }
        return sub
    }

    public func userSub() -> String? {
        return self.tokenValue(for: "sub")
    }

    func jwtDecode(jwtToken jwt: String) -> [String: Any]? {
        let segments = jwt.components(separatedBy: ".")
        guard segments.count > 2 else { return nil }
        return decodeJWTPart(segments[1])
    }

    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }

        return payload
    }

    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
