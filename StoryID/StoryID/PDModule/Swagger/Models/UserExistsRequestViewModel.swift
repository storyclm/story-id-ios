//
// UserExistsRequestViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UserExistsRequestViewModel: Codable {

    public var login: String
    public var client: String
    public var secret: String

    public init(login: String, client: String, secret: String) {
        self.login = login
        self.client = client
        self.secret = secret
    }


}
