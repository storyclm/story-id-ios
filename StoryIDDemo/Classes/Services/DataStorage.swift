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

    // MARK: * ITN

    func itn(completion: @escaping (ItnModel) -> Void) {
        let profileItn = SIDPersonalDataService.instance.profileItn

        profileItn.itnImage { (image) in
            let result = ItnModel(with: profileItn.itn())
            result.itnImage = image
            completion(result)
        }
    }

    func setItn(_ model: ItnModel?) {
        let profileItn = SIDPersonalDataService.instance.profileItn

        if let model = model {
            profileItn.setItn(itn: model.itn)
            profileItn.setItnImage(model.itnImage)
        } else {
            profileItn.deleteItn()
        }
    }

    // MARK: * SNILS

    func snils(completion: @escaping (SnilsModel) -> Void) {
        let profileSnils = SIDPersonalDataService.instance.profileSnils

        profileSnils.snilsImage { image in
            let result = SnilsModel(with: profileSnils.snils())
            result.snilsImage = image
            completion(result)
        }
    }

    func setSnils(_ model: SnilsModel?) {
        let profileSnils = SIDPersonalDataService.instance.profileSnils

        if let model = model {
            profileSnils.setSnils(model.snils)
            profileSnils.setSnilsImage(model.snilsImage)
        } else {
            profileSnils.deleteSnils()
        }
    }

    // MARK: * Pasport

    func pasport(completion: @escaping (PasportModel) -> Void) {
        let profilePasport = SIDPersonalDataService.instance.profilePasport

        var page1: UIImage?
        var page2: UIImage?

        let group = DispatchGroup()
        group.enter()
        profilePasport.pasportImage(page: 1) { image in
            page1 = image
            group.leave()
        }

        group.enter()
        profilePasport.pasportImage(page: 2) { image in
            page2 = image
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            let result = PasportModel(with: profilePasport.passport())
            result.firstImage = page1
            result.secondImage = page2

            completion(result)
        }
    }

    func setPasport(_ model: PasportModel?) {
        let profilePasport = SIDPersonalDataService.instance.profilePasport

        if let model = model {
            profilePasport.setPasport(code: model.code, sn: model.sn, issuedBy: model.issuedBy, issuedAt: model.issuedAt)
            profilePasport.setPasportImage(model.firstImage, page: 1)
            profilePasport.setPasportImage(model.secondImage, page: 2)
        } else {
            profilePasport.deletePasport()
        }
    }

    // MARK: - Bank Data

    var bankAccounts: [BankAccountModel]? {
        get { BankAccountModel.models(from: SIDPersonalDataService.instance.bankAccounts.bankAccounts()) }
        set {
            let service = SIDPersonalDataService.instance.bankAccounts
            if let newValue = newValue {
                for account in newValue {
                    guard let uuid = account.uuid else { continue }
                    service.setBankAccount(id: uuid,
                                           accountName: account.accountName,
                                           bic: account.bic,
                                           bank: account.bankName,
                                           correspondentAccount: account.correspondentAccount,
                                           settlementAccount: account.settlementAccount)
                }
            } else {
                service.deleteAllBankAccounts()
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
        self.bankAccounts = nil
        
        self.setItn(nil)
        self.setSnils(nil)
        self.setPasport(nil)

        self.avatarImage = nil

        PincodeService.instance.pincode = nil
        PincodeService.instance.isLogined = false
    }
}
