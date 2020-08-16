//
// CreateApplicationViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CreateApplicationViewModel: Codable {

    public var name: String?
    public var _description: String?
    public var appType: StoryAppType?
    public var enabled: Bool?
    public var expiration: Int?
    public var redirectUri: String?
    public var postLogoutRedirectUri: String?
    public var _id: String?
    public var ticks: Int64?

    public init(name: String?, _description: String?, appType: StoryAppType?, enabled: Bool?, expiration: Int?, redirectUri: String?, postLogoutRedirectUri: String?, _id: String?, ticks: Int64?) {
        self.name = name
        self._description = _description
        self.appType = appType
        self.enabled = enabled
        self.expiration = expiration
        self.redirectUri = redirectUri
        self.postLogoutRedirectUri = postLogoutRedirectUri
        self._id = _id
        self.ticks = ticks
    }

    public enum CodingKeys: String, CodingKey { 
        case name
        case _description = "description"
        case appType
        case enabled
        case expiration
        case redirectUri
        case postLogoutRedirectUri
        case _id = "id"
        case ticks
    }

}

