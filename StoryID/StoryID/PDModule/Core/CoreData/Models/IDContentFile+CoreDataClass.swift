//
//  IDContentFile+CoreDataClass.swift
//  
//
//  Created by Sergey Ryazanov on 15.06.2020.
//
//

import Foundation
import CoreData

@objc(IDContentFile)
public class IDContentFile: NSManagedObject {}

extension IDContentFile: SIDCoreDataModelUpdatable {}
