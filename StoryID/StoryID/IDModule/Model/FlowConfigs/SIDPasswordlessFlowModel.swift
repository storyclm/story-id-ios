//
//  SIDPasswordlessFlowModel.swift
//  idModule
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import p2_OAuth2

public final class SIDPasswordlessFlowModel: SIDBaseFlowModel {

    let login: String
    let appendingPath: String

    public init(clientId: String, clientSecret: String, authorizeURL: String, login: String, appendingPath: String = "verify/code", tokenURL: String?) {
        self.login = login
        self.appendingPath = appendingPath

        super.init(clientId: clientSecret, clientSecret: clientSecret, authorizeURL: authorizeURL, tokenURL: tokenURL)
    }

    public init(adapter: OAuth2, login: String, appendingPath: String = "verify/code") {
        self.login = login
        self.appendingPath = appendingPath

        super.init(adapter: adapter)
    }

    override public func settings() -> OAuth2JSON {
        var settings = super.settings()
        settings["login"] = self.login

        return settings
    }
}
