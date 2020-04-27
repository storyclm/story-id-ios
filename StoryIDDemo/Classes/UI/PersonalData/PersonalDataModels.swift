//
//  PersonalDataModels.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class DemographicsModel: Codable {
    var surname: String?
    var name: String?
    var patronymic: String?
    var phoneNumber: String?
    var email: String?
}

final class ItnModel: Codable {
    var itn: String?
    var itnImageData: Data?

    var itnImage: UIImage? {
        set { self.itnImageData = newValue?.pngData() }
        get {
            guard let data = self.itnImageData else { return nil }
            return UIImage(data: data)
        }
    }
}

final class SnilsModel: Codable {
    var snils: String?
    var snilsImageData: Data?

    var snilsImage: UIImage? {
        set { self.snilsImageData = newValue?.pngData() }
        get {
            guard let data = self.snilsImageData else { return nil }
            return UIImage(data: data)
        }
    }
}

final class PasportModel: Codable {
    var sn: String?
    var firstImageData: Data?
    var secondImageData: Data?

    var firstImage: UIImage? {
        set { self.firstImageData = newValue?.pngData() }
        get {
            guard let data = self.firstImageData else { return nil }
            return UIImage(data: data)
        }
    }

    var secondImage: UIImage? {
        set { self.secondImageData = newValue?.pngData() }
        get {
            guard let data = self.secondImageData else { return nil }
            return UIImage(data: data)
        }
    }
}
