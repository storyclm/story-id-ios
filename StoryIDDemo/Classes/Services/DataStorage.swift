//
//  DataStorage.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class DataStorage {

    static let instance = DataStorage()

    private init() {}

    // MARK: - Personal Data

    private let demographicsName = "demographics.json"
    var demographics: DemographicsModel? {
        get {
            guard Storage.fileExists(demographicsName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(demographicsName, from: Storage.Directory.documents, as: DemographicsModel.self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: demographicsName)
            } else {
                Storage.remove(demographicsName, from: Storage.Directory.documents)
            }
        }
    }

    private let itnName = "itn.json"
    var itn: ItnModel? {
        get {
            guard Storage.fileExists(itnName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(itnName, from: Storage.Directory.documents, as: ItnModel.self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: itnName)
            } else {
                Storage.remove(itnName, from: Storage.Directory.documents)
            }
        }
    }

    private let snilsName = "snils.json"
    var snils: SnilsModel? {
        get {
            guard Storage.fileExists(snilsName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(snilsName, from: Storage.Directory.documents, as: SnilsModel.self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: snilsName)
            } else {
                Storage.remove(snilsName, from: Storage.Directory.documents)
            }
        }
    }

    private let pasportName = "pasport.json"
    var pasport: PasportModel? {
        get {
            guard Storage.fileExists(pasportName, in: Storage.Directory.documents) else { return nil }
            return Storage.retrieve(pasportName, from: Storage.Directory.documents, as: PasportModel.self)
        }
        set {
            if let newValue = newValue {
                Storage.store(newValue, to: Storage.Directory.documents, as: pasportName)
            } else {
                Storage.remove(pasportName, from: Storage.Directory.documents)
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
