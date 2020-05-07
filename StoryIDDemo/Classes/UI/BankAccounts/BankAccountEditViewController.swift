//
//  BankAccountEditViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class BankAccountEditViewController: BaseFormViewController {

    private let isNewAccount: Bool
    private let viewModel: BankAccountModel
    private let completion: (BankAccountModel?) -> Void

    init(viewModel: BankAccountModel?, completion: @escaping (BankAccountModel?) -> Void) {
        if let viewModel = viewModel?.copy() as? BankAccountModel {
            self.viewModel = viewModel
            self.isNewAccount = false
        } else {
            self.viewModel = BankAccountModel()
            self.isNewAccount = true
        }
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = isNewAccount ? "bank_account_edit_new_title".loco : "bank_account_edit_edit_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        let nameRow = self.createTitleFieldRow(title: nil, configure: {[unowned self] row in
            row.text = self.viewModel.accountName
        }, onTextChanged: {[unowned self] newName in
            self.viewModel.accountName = newName
        })

        let nameSection = SectionFormer(rowFormer: nameRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_account_name".loco))

        let bicRow = self.createTitleFieldRow(title: nil, configure: {[unowned self] row in
            row.text = self.viewModel.bic
        }, onTextChanged: {[unowned self] newBic in
            self.viewModel.bic = newBic
        })

        let bicSection = SectionFormer(rowFormer: bicRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_bik".loco))

        let bankNameRow = self.createTitleFieldRow(title: nil, configure: {[unowned self] row in
            row.text = self.viewModel.bankName
        }, onTextChanged: {[unowned self] newBankName in
            self.viewModel.bankName = newBankName
        })

        let bankSection = SectionFormer(rowFormer: bankNameRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_bank_name".loco))

        let correspondentRow = self.createTitleFieldRow(title: nil, configure: {[unowned self] row in
            row.text = self.viewModel.correspondentAccount
        }, onTextChanged: {[unowned self] newCorrespondent in
            self.viewModel.correspondentAccount = newCorrespondent
        })

        let correspondentSection = SectionFormer(rowFormer: correspondentRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_correspondent".loco))

        let settlementRow = self.createTitleFieldRow(title: nil, configure: {[unowned self] row in
            row.text = self.viewModel.settlementAccount
        }, onTextChanged: {[unowned self] newSettlement in
            self.viewModel.settlementAccount = newSettlement
        })

        let settlementSection = SectionFormer(rowFormer: settlementRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_settlement".loco))

        former.append(sectionFormer: nameSection, bicSection, bankSection, correspondentSection, settlementSection)
    }

    // MARK: - Save

    override func cancelButtonAction(_ sender: UIBarButtonItem) {
        completion(nil)
        super.cancelButtonAction(sender)
    }

    override func onSave() {
        if self.isAccountNameFilled() {
            super.onSave()
            completion(viewModel)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showAccountNameAlert()
        }
    }

    // MARK: - Account name

    private func isAccountNameFilled() -> Bool {
        let accountName = self.viewModel.accountName?.trimmingCharacters(in: CharacterSet.whitespaces)
        if let accountName = accountName, accountName.isEmpty == false {
            return true
        }
        return false
    }

    private func showAccountNameAlert() {
        let alert = UIAlertController(title: "bank_account_edit_alert_title".loco, message: "bank_account_edit_alert_text".loco, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "global_ok".loco, style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }
}
