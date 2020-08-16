//
//  IDContentSNILS+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentSNILS)
public class IDContentSNILS: NSManagedObject {}

extension IDContentSNILS: SIDCoreDataUserIdContainable {}

extension IDContentSNILS: SIDCoreDataModelUpdatable {}
