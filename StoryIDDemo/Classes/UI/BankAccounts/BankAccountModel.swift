//
//  BankAccountModel.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import StoryID

final class BankAccountModel: NSCopying {
    var uuid: String?
    var accountName: String?
    var bankName: String?
    var bic: String?
    var correspondentAccount: String?
    var settlementAccount: String?

    init(with dbModel: IDContentBankAccount?) {
        if let dbModel = dbModel {
            self.uuid = dbModel.id ?? UUID().uuidString
            self.accountName = dbModel.name
            self.bankName = dbModel.bank
            self.bic = dbModel.bic
            self.correspondentAccount = dbModel.correspondentAccount
            self.settlementAccount = dbModel.settlementAccount
        } else {
            self.uuid = UUID().uuidString
        }
    }

    var isEmpty: Bool {
        self.accountName?.notEmptyValue == nil &&
            self.bankName?.notEmptyValue == nil &&
            self.bic?.notEmptyValue == nil &&
            self.correspondentAccount?.notEmptyValue == nil &&
            self.settlementAccount?.notEmptyValue == nil
    }

    // MARK: - Array

    class func models(from dbModels: [IDContentBankAccount]?) -> [BankAccountModel]? {
        guard let dbModels = dbModels else { return nil }
        return dbModels.map { BankAccountModel(with: $0) }
    }

    // MARK: - NSCopying

    func copy(with zone: NSZone? = nil) -> Any {
        let bankAccountModel = BankAccountModel(with: nil)
        bankAccountModel.uuid = uuid
        bankAccountModel.accountName = accountName
        bankAccountModel.bankName = bankName
        bankAccountModel.bic = bic
        bankAccountModel.correspondentAccount = correspondentAccount
        bankAccountModel.settlementAccount = settlementAccount

        return bankAccountModel
    }
}
