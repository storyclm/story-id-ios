//
//  SIDCoreDataProtocol.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 08.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import CoreData

protocol SIDCoreDataUserIdContainable {
    var userId: String? { get set }
}

protocol SIDCoreDataModelUpdatable {
    var profileId: String? { get set }
    var modifiedAt: Date? { get set }

    func updateModifyAt() throws
}

extension SIDCoreDataModelUpdatable {

    func updateModifyAt() throws {
        var model = self
        model.modifiedAt = Date()

        if let managedObject = self as? NSManagedObject {
            try managedObject.managedObjectContext?.save()
        }
        
    }
}
