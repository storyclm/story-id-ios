//
//  IDContentPasport+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentPasport)
public class IDContentPasport: NSManagedObject {}

extension IDContentPasport: SIDCoreDataUserIdContainable {}

extension IDContentPasport: SIDCoreDataModelUpdatable {}
