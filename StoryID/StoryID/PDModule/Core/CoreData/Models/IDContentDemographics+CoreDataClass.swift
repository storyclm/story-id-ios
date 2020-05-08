//
//  IDContentDemographics+CoreDataClass.swift
//
//
//  Created by Sergey Ryazanov on 08.05.2020.
//
//

import Foundation
import CoreData

@objc(IDContentDemographics)
public class IDContentDemographics: NSManagedObject {}

extension IDContentDemographics: SIDCoreDataUserIdContainable {}

extension IDContentDemographics: SIDCoreDataModelUpdatable {}
