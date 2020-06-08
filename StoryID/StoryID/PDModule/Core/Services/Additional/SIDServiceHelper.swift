//
//  SIDServiceHelper.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

public final class SIDServiceHelper {

    public enum ServiceError: Error {
        case alreadyInSync
        case serverIdIsMissed
        case syncDisabled
        case dataIsMissed
        case nothingToUpdate
        case nsError(NSError)
    }

    enum ServiceUpdateBehaviour {
        case update
        case send
        case skip
    }

    public typealias SynchronizeBlock = (ServiceError?) -> Void

    class var userId: String? { AlamofireRetrier.retrier?.loader.oauth2.userSub() }

    static func updateBehaviour(localModel: SIDCoreDataModelUpdatable?, serverDate: Date?) -> ServiceUpdateBehaviour {
        guard localModel?.profileId != nil else { return ServiceUpdateBehaviour.update }
        guard let localDate = localModel?.modifiedAt else { return ServiceUpdateBehaviour.update }
        guard let serverDate = serverDate else { return ServiceUpdateBehaviour.send }

        if localDate == serverDate {
            return ServiceUpdateBehaviour.skip
        } else if localDate < serverDate {
            return ServiceUpdateBehaviour.update
        } else {
            return ServiceUpdateBehaviour.send
        }
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
