//
//  IDContentBankAccount+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentBankAccount)
public class IDContentBankAccount: NSManagedObject {}

extension IDContentBankAccount: SIDCoreDataUserIdContainable {}

extension IDContentBankAccount: SIDCoreDataModelUpdatable {}
