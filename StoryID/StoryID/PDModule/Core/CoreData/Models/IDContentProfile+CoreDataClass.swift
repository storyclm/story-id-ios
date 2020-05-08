//
//  IDContentProfile+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentProfile)
public class IDContentProfile: NSManagedObject {}

extension IDContentProfile: SIDCoreDataUserIdContainable {}

extension IDContentProfile: SIDCoreDataModelUpdatable {
    var profileId: String? {
        get { self.id }
        set { self.id = newValue }
    }
}
