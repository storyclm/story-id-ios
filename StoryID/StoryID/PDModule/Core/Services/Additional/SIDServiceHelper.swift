//
//  SIDServiceHelper.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

public final class SIDServiceHelper {

    class var userId: String? { AlamofireRetrier.retrier?.loader.oauth2.userSub() }

    public typealias SynchronizeBlock = (ServiceError?) -> Void

    public enum ServiceError: Error {
        case serverIdIsMissed
        case syncDisabled
        case dataIsMissed
        case nothingToUpdate
        case nsError(NSError)
    }
}

public extension Error {

    var asServiceError: SIDServiceHelper.ServiceError {
        if let serviceError = self as? SIDServiceHelper.ServiceError {
            return serviceError
        }
        return SIDServiceHelper.ServiceError.nsError(self as NSError)
    }
}
