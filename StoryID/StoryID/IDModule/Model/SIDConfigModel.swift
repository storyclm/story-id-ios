//
//  SIDConfigModel.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public struct SIDConfigModel: Codable {

    let issuer: String
    let jwks_uri: String
    let authorization_endpoint: String
    let token_endpoint: String
    let userinfo_endpoint: String
    let end_session_endpoint: String
    let check_session_iframe: String
    let revocation_endpoint: String
    let introspection_endpoint: String

    let frontchannel_logout_supported: Bool
    let frontchannel_logout_session_supported: Bool
    let backchannel_logout_supported: Bool
    let backchannel_logout_session_supported: Bool

    let scopes_supported: [String]
    let claims_supported: [String]
    let grant_types_supported: [String]
    let response_types_supported: [String]
    let response_modes_supported: [String]
    let token_endpoint_auth_methods_supported: [String]
    let subject_types_supported: [String]
    let id_token_signing_alg_values_supported: [String]
    let code_challenge_methods_supported: [String]
}
