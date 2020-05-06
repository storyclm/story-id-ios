//
//  SIDProfileDemographicsService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public class SIDProfileDemographicsService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        completion(nil)
    }

    // MARK: - Public

    public func demographics() -> IDContentDemographics? {
        return IDContentDemographics.firstModel()
    }

    public func setDemographics(name: String?, surname: String?, patronymic: String?, gender: Bool, birthday: Date?) {
        let demographicsModel = self.demographics() ?? IDContentDemographics.create()
        demographicsModel.name = name
        demographicsModel.surname = surname
        demographicsModel.patronymic = patronymic
        demographicsModel.gender = gender
        demographicsModel.birthday = birthday
        demographicsModel.modifiedAt = Date()
        demographicsModel.isEntityDeleted = false

        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteDemographics() {
        self.demographics()?.deleteModel()
        SIDCoreDataManager.instance.saveContext()
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var gender: Bool
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var patronymic: String?
}
