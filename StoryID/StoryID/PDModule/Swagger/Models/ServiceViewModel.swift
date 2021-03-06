//
// ServiceViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct ServiceViewModel: Codable {

    public var name: String
    public var _description: String?
    public var scopes: [String]?
    public var createdAt: Date?
    public var createdBy: String?
    public var modifiedAt: Date?
    public var modifiedBy: String?
    public var _id: String?

    public init(name: String, _description: String?, scopes: [String]?, createdAt: Date?, createdBy: String?, modifiedAt: Date?, modifiedBy: String?, _id: String?) {
        self.name = name
        self._description = _description
        self.scopes = scopes
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.modifiedAt = modifiedAt
        self.modifiedBy = modifiedBy
        self._id = _id
    }

    public enum CodingKeys: String, CodingKey { 
        case name
        case _description = "description"
        case scopes
        case createdAt
        case createdBy
        case modifiedAt
        case modifiedBy
        case _id = "id"
    }

}

