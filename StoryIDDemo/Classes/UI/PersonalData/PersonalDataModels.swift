//
//  PersonalDataModels.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class DemographicsModel {
    var surname: String?
    var name: String?
    var patronymic: String?

    init(with dbModel: IDContentDemographics?) {
        if let dbModel = dbModel {
            self.surname = dbModel.surname
            self.name = dbModel.name
            self.patronymic = dbModel.patronymic
        }
    }
}

final class ItnModel {
    var itn: String?
    var itnImage: UIImage?

    init(with dbModel: IDContentITN?) {
        if let dbModel = dbModel {
            self.itn = dbModel.itn
        }
    }
}

final class SnilsModel {
    var snils: String?
    var snilsImage: UIImage?

    init(with dbModel: IDContentSNILS?) {
        if let dbModel = dbModel {
            self.snils = dbModel.snils
        }
    }
}

final class PasportModel {

    var sn: String?
    var code: String?
    var issuedAt: Date?
    var issuedBy: String?
    var firstImage: UIImage?
    var secondImage: UIImage?

    init(with dbModel: IDContentPasport?) {
        if let dbModel = dbModel {
            self.sn = dbModel.sn
            self.code = dbModel.code
            self.issuedAt = dbModel.issuedAt
            self.issuedBy = dbModel.issuedBy
        }
    }
}
