//
// AppUserDTO.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct AppUserDTO: Codable {

    public var userId: String
    public var blockDescription: String?
    public var blocked: Bool?
    public var blockedUntil: Date?
    public var blockedAt: Date?
    public var blockedBy: String?

    public init(userId: String, blockDescription: String?, blocked: Bool?, blockedUntil: Date?, blockedAt: Date?, blockedBy: String?) {
        self.userId = userId
        self.blockDescription = blockDescription
        self.blocked = blocked
        self.blockedUntil = blockedUntil
        self.blockedAt = blockedAt
        self.blockedBy = blockedBy
    }


}

