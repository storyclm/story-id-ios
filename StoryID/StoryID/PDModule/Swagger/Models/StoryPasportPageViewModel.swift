//
// StoryPasportPageViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct StoryPasportPageViewModel: Codable {

    public var modifiedAt: Date?
    public var modifiedBy: String?
    public var size: Int64?
    public var mimeType: String?
    public var page: Int

    public init(modifiedAt: Date?, modifiedBy: String?, size: Int64?, mimeType: String?, page: Int) {
        self.modifiedAt = modifiedAt
        self.modifiedBy = modifiedBy
        self.size = size
        self.mimeType = mimeType
        self.page = page
    }


}

