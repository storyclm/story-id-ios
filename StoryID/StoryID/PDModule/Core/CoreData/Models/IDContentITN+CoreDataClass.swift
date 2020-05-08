//
//  IDContentITN+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentITN)
public class IDContentITN: NSManagedObject {}

extension IDContentITN: SIDCoreDataUserIdContainable {}

extension IDContentITN: SIDCoreDataModelUpdatable {}
