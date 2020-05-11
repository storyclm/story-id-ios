//
//  SIDProfileBankAccountsService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 11.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public class SIDProfileBankAccountsService: SIDServiceProtocol {

    public var isSynchronizable: Bool = true

    public func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock) {
        func complete(error: SIDServiceHelper.ServiceError?) {
            completion(error)
            self.clearDeleted()
        }

        ProfileBankAccountsAPI.listBankAccounts { bankAccounts, error in
            if let error = error {
                complete(error: error.asServiceError)
            } else if let bankAccounts = bankAccounts {
                let updateGroup = DispatchGroup()
                var errors: [SIDServiceHelper.ServiceError] = []

                for serverAccount in bankAccounts {
                    self.update(with: serverAccount) { error in
                        if let error = error {
                            errors.append(error)
                        }
                    }
                }

                updateGroup.notify(queue: DispatchQueue.main) {
                    complete(error: errors.first) // TODO: Send all errors
                }
            } else {
                complete(error: nil)
            }
        }
    }

    private func update(with serverModel: StoryBankAccount, completion: @escaping (SIDServiceHelper.ServiceError?) -> Void) {
        guard let serverId = serverModel._id else {
            completion(nil)
            return
        }

        let localBankAccount = self.bankAccount(with: serverId)

        let updateBehaviour = SIDServiceHelper.updateBehaviour(localModel: localBankAccount, serverDate: serverModel.modifiedAt)

        switch updateBehaviour {
        case .update:
            self.updateLocalModel(localBankAccount, with: serverModel)
            completion(nil)
        case .send:
            if let bankAccount = localBankAccount, let id = bankAccount.id, let name = bankAccount.name {
                self.sendBankAccount(id: id,
                                     accountName: name,
                                     description: bankAccount.accountDescription,
                                     bic: bankAccount.bic,
                                     bank: bankAccount.bank,
                                     correspondentAccount: bankAccount.correspondentAccount,
                                     settlementAccount: bankAccount.settlementAccount) { _, error in
                                        completion(error?.asServiceError)
                }
            } else {
                completion(nil)
            }
        case .skip:
            completion(nil)
        }
    }

    private func updateLocalModel(_ localModel: IDContentBankAccount?, with serverModel: StoryBankAccount, isCreateIfNeeded: Bool = true) {

        var localModel = localModel
        if isCreateIfNeeded, localModel == nil {
            localModel = IDContentDemographics.create()
        }

        guard let lModel = localModel else { return }

        lModel.id = serverModel._id
        lModel.accountDescription = serverModel._description
        lModel.name = serverModel.name
        lModel.bic = serverModel.bic
        lModel.bank = serverModel.bank
        lModel.correspondentAccount = serverModel.correspondentAccount
        lModel.settlementAccount = serverModel.settlementAccount

        lModel.isEntityDeleted = false
        lModel.profileId = serverModel.profileId
        lModel.modifiedAt = serverModel.modifiedAt
        lModel.modifiedBy = serverModel.modifiedBy
        lModel.verified = serverModel.verified ?? false
        lModel.verifiedAt = serverModel.verifiedAt
        lModel.modifiedBy = serverModel.modifiedBy

        SIDCoreDataManager.instance.saveContext()
    }

    private func sendBankAccount(id: String,
                                 accountName: String,
                                 description: String?,
                                 bic: String?,
                                 bank: String?,
                                 correspondentAccount: String?,
                                 settlementAccount: String?,
                                 completion: @escaping (StoryBankAccount?, Error?) -> Void) {

        let body = StoryBankAccountDTO(name: accountName, _description: description, settlementAccount: settlementAccount, bank: bank, bic: bic, correspondentAccount: correspondentAccount)
        ProfileBankAccountsAPI.updateBankAccount(_id: id, body: body, completion: completion)
    }

    private func clearDeleted() {
        guard let modelsForDeletion: [IDContentBankAccount] = IDContentBankAccount.models(userID: nil, deleteConduct: SIDDeleteConduct.only) else { return }

        let serverGroup = DispatchGroup()

        var deletedModels: [IDContentBankAccount] = []
        for model in modelsForDeletion {
            guard let id = model.id, let name = model.name else { continue }

            serverGroup.enter()

            self.sendBankAccount(id: id,
                                 accountName: name,
                                 description: model.accountDescription,
                                 bic: model.bic,
                                 bank: model.bank,
                                 correspondentAccount: model.correspondentAccount,
                                 settlementAccount: model.settlementAccount) { _, error in
                                    if error == nil {
                                        deletedModels.append(model)
                                    }
                                    serverGroup.leave()
            }
        }

        serverGroup.notify(queue: DispatchQueue.main) {
            deletedModels.forEach { $0.deleteModel() }
        }

        SIDCoreDataManager.instance.saveContext()
    }

    // MARK: - Public

    public func bankAccounts() -> [IDContentBankAccount]? {
        return IDContentBankAccount.models()
    }

    public func bankAccount(with id: String) -> IDContentBankAccount? {
        guard let models = self.bankAccounts() else { return nil }
        return models.first(where: { $0.id == id })
    }

    public func setBankAccount(id: String,
                               accountName: String?,
                               bic: String?,
                               bank: String?,
                               correspondentAccount: String?,
                               settlementAccount: String?) {
        let bankAccountModel = self.bankAccount(with: id) ?? IDContentBankAccount.create()
        bankAccountModel.id = id
        bankAccountModel.name = accountName
        bankAccountModel.bic = bic
        bankAccountModel.bank = bank
        bankAccountModel.correspondentAccount = correspondentAccount
        bankAccountModel.settlementAccount = settlementAccount

        bankAccountModel.isEntityDeleted = false
        bankAccountModel.modifiedAt = Date()

        SIDCoreDataManager.instance.saveContext()
    }

    public func deleteBankAccount(with id: String) {
        if let model = self.bankAccount(with: id) {
            model.isEntityDeleted = true

            SIDCoreDataManager.instance.saveContext()
        }
    }

    public func deleteAllBankAccounts() {
        self.bankAccounts()?.forEach { $0.isEntityDeleted = true }
        
    }
}
