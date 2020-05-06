//
// StoryAppUser.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct StoryAppUser: Codable {

    public var appId: String
    public var userId: String
    public var blockDescription: String?
    public var blocked: Bool?
    public var blockedUntil: Date?
    public var blockedAt: Date?
    public var blockedBy: String?
    public var createdAt: Date?
    public var createdBy: String?
    public var modifiedAt: Date?
    public var modifiedBy: String?
    public var _id: String?

    public init(appId: String, userId: String, blockDescription: String?, blocked: Bool?, blockedUntil: Date?, blockedAt: Date?, blockedBy: String?, createdAt: Date?, createdBy: String?, modifiedAt: Date?, modifiedBy: String?, _id: String?) {
        self.appId = appId
        self.userId = userId
        self.blockDescription = blockDescription
        self.blocked = blocked
        self.blockedUntil = blockedUntil
        self.blockedAt = blockedAt
        self.blockedBy = blockedBy
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.modifiedAt = modifiedAt
        self.modifiedBy = modifiedBy
        self._id = _id
    }

    public enum CodingKeys: String, CodingKey { 
        case appId
        case userId
        case blockDescription
        case blocked
        case blockedUntil
        case blockedAt
        case blockedBy
        case createdAt
        case createdBy
        case modifiedAt
        case modifiedBy
        case _id = "id"
    }

}

