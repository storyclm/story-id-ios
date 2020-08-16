//
// UpdateFileViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct UpdateFileViewModel: Codable {

    public var fileName: String?
    public var mimeType: String?
    public var name: String
    public var category: String?
    public var _description: String?

    public init(fileName: String?, mimeType: String?, name: String, category: String?, _description: String?) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.name = name
        self.category = category
        self._description = _description
    }

    public enum CodingKeys: String, CodingKey { 
        case fileName
        case mimeType
        case name
        case category
        case _description = "description"
    }

}
