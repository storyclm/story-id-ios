//
//  BankAccountModel.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class BankAccountModel: Codable, NSCopying {
    var uuid: String
    var accountName: String?
    var bankName: String?
    var bic: String?
    var correspondentAccount: String?
    var settlementAccount: String?

    init() {
        self.uuid = UUID().uuidString
    }

    var isEmpty: Bool {
        self.accountName?.notEmptyValue == nil &&
            self.bankName?.notEmptyValue == nil &&
            self.bic?.notEmptyValue == nil &&
            self.correspondentAccount?.notEmptyValue == nil &&
            self.settlementAccount?.notEmptyValue == nil
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let bankAccountModel = BankAccountModel()
        bankAccountModel.uuid = uuid
        bankAccountModel.accountName = accountName
        bankAccountModel.bankName = bankName
        bankAccountModel.bic = bic
        bankAccountModel.correspondentAccount = correspondentAccount
        bankAccountModel.settlementAccount = settlementAccount

        return bankAccountModel
    }
}
