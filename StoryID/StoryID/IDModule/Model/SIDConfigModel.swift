//
//  SIDConfigModel.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public struct SIDConfigModel: Codable {

    public let issuer: String
    public let jwks_uri: String
    public let authorization_endpoint: String
    public let token_endpoint: String
    public let userinfo_endpoint: String
    public let end_session_endpoint: String
    public let check_session_iframe: String
    public let revocation_endpoint: String
    public let introspection_endpoint: String

    public let frontchannel_logout_supported: Bool
    public let frontchannel_logout_session_supported: Bool
    public let backchannel_logout_supported: Bool
    public let backchannel_logout_session_supported: Bool

    public let scopes_supported: [String]
    public let claims_supported: [String]
    public let grant_types_supported: [String]
    public let response_types_supported: [String]
    public let response_modes_supported: [String]
    public let token_endpoint_auth_methods_supported: [String]
    public let subject_types_supported: [String]
    public let id_token_signing_alg_values_supported: [String]
    public let code_challenge_methods_supported: [String]
}
