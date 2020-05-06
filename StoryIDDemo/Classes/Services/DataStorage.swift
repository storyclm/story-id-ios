//
//  DataStorage.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class DataStorage {

    static let instance = DataStorage()

    private init() {}

    // MARK: - Personal Data

    var demographics: DemographicsModel? {
        get { DemographicsModel(with: SIDPersonalDataService.instance.profileDemographics.demographics()) }
        set {
            if let newValue = newValue {
                SIDPersonalDataService.instance.profileDemographics.setDemographics(name: newValue.name, surname: newValue.surname, patronymic: newValue.patronymic, gender: false, birthday: nil)
            } else {
                SIDPersonalDataService.instance.profileDemographics.deleteDemographics()
            }
        }
    }

    var itn: ItnModel? {
        get {
            let result = ItnModel(with: SIDPersonalDataService.instance.profileItn.itn())
            result.itnImage = SIDPersonalDataService.instance.profileItn.itnImage()
            return result
        }
        set {
            if let newValue = newValue {
                SIDPersonalDataService.instance.profileItn.setItn(itn: newValue.itn)
                SIDPersonalDataService.instance.profileItn.setItnImage(newValue.itnImage)
            } else {
                SIDPersonalDataService.instance.profileItn.deleteItn()
            }
        }
    }

    var snils: SnilsModel? {
        get {
            let result = SnilsModel(with: SIDPersonalDataService.instance.profileSnils.snils())
            result.snilsImage = SIDPersonalDataService.instance.profileSnils.snilsImage()
            return result
        }
        set {
            if let newValue = newValue {
                SIDPersonalDataService.instance.profileSnils.setSnils(newValue.snils)
                SIDPersonalDataService.instance.profileSnils.setSnilsImage(newValue.snilsImage)
            } else {
                SIDPersonalDataService.instance.profileSnils.deleteSnils()
            }
        }
    }

    var pasport: PasportModel? {
        get {
            let result = PasportModel(with: SIDPersonalDataService.instance.profilePasport.passport())
            result.firstImage = SIDPersonalDataService.instance.profilePasport.pasportImage(page: 1)
            result.secondImage = SIDPersonalDataService.instance.profilePasport.pasportImage(page: 2)
            return result
        }
        set {
            if let newValue = newValue {
                SIDPersonalDataService.instance.profilePasport.setPasport(code: nil, sn: newValue.sn, issuedBy: nil, issuedAt: nil)
                SIDPersonalDataService.instance.profilePasport.setPasportImage(newValue.firstImage, page: 1)
                SIDPersonalDataService.instance.profilePasport.setPasportImage(newValue.secondImage, page: 2)
            } else {
                SIDPersonalDataService.instance.profilePasport.deletePasport()
            }
        }
    }

    // MARK: - Bank Data

    private let bankName = "bankAccounts.json"
    var bankAccounts: [BankAccountModel]? {
        get {
            guard Storage.fileExists(bankName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(bankName, from: Storage.Directory.documents, as: [BankAccountModel].self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: bankName)
            } else {
                Storage.remove(bankName, from: Storage.Directory.documents)
            }
        }
    }

    // MARK: - UserImage

    private let avatarName = "avatar.json"
    private var userAvatarData: Data? {
        get {
            guard Storage.fileExists(avatarName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(avatarName, from: Storage.Directory.documents, as: Data.self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: avatarName)
            } else {
                Storage.remove(avatarName, from: Storage.Directory.documents)
            }
        }
    }

    var avatarImage: UIImage? {
        set { self.userAvatarData = newValue?.pngData() }
        get {
            guard let data = self.userAvatarData else { return nil }
            return UIImage(data: data)
        }
    }

    // MARK: - Logout

    func logout() {
        self.demographics = nil
        self.itn = nil
        self.snils = nil
        self.pasport = nil
        self.bankAccounts = nil

        PincodeService.instance?.pincode = nil
        PincodeService.instance?.isLogined = false

        Storage.clear(Storage.Directory.documents)
    }
}
