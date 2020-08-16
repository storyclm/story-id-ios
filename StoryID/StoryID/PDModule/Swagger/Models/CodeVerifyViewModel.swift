//
// CodeVerifyViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CodeVerifyViewModel: Codable {

    public var expiration: Date
    public var signature: String
    public var code: String
    public var login: String
    public var client: String
    public var secret: String

    public init(expiration: Date, signature: String, code: String, login: String, client: String, secret: String) {
        self.expiration = expiration
        self.signature = signature
        self.code = code
        self.login = login
        self.client = client
        self.secret = secret
    }


}
