//
//  SIDPasswordFlowModel.swift
//  idModule
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import p2_OAuth2

public final class SIDPasswordFlowModel: SIDBaseFlowModel {

    let username: String
    let password: String

    public init(clientId: String, clientSecret: String, authorizeURL: String, username: String, password: String, tokenURL: String?) {
        self.username = username
        self.password = password

        super.init(clientId: clientSecret, clientSecret: clientSecret, authorizeURL: authorizeURL, tokenURL: tokenURL)
    }

    public init(adapter: OAuth2, username: String, password: String) {
        self.username = username
        self.password = password

        super.init(adapter: adapter)
    }

    public override func settings() -> OAuth2JSON {
        var settings = super.settings()
        settings["username"] = self.username
        settings["password"] = self.password

        return settings
    }
}
