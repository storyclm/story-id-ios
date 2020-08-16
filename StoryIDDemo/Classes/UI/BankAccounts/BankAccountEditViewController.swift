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
            self.viewModel = BankAccountModel(with: nil)
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

        let nameRow = self.createSimpleTitleFieldRow(title: nil, configure: { [unowned self] row in
            row.text = self.viewModel.accountName
        }, onTextChanged: { [unowned self] text in
            self.viewModel.accountName = text
        })

        let nameSection = SectionFormer(rowFormer: nameRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_account_name".loco))

        let bicRow = self.createMaskedTitleFieldRow(title: nil,
                                                    primaryMaskFormat: "[00]-[00]-[00]-[000]",
                                                    onValidate: { $0?.count ?? 0 == 9 },
                                                    configure: { [unowned self] row in
                                                        row.value = self.viewModel.bic
                                                        row.cell.textField.placeholder = "bank_account_edit_bik_placeholder".loco
                                                        row.cell.textField.keyboardType = UIKeyboardType.numberPad
                                                        row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        }, onTextChanged: { [unowned self] text, value in
            self.viewModel.bic = value
        })

        let bicSection = SectionFormer(rowFormer: bicRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_bik".loco))

        let bankNameRow = self.createSimpleTitleFieldRow(title: nil,
                                                         configure: { [unowned self] row in
                                                            row.text = self.viewModel.bankName
        }, onTextChanged: { [unowned self] text in
            self.viewModel.bankName = text
        })

        let bankSection = SectionFormer(rowFormer: bankNameRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_bank_name".loco))

        let correspondentRow = self.createMaskedTitleFieldRow(title: nil,
                                                              primaryMaskFormat: "[000]-[00]-[000]-[0]-[0000]-[0000000]",
                                                              onValidate: { $0?.count ?? 0 == 20 },
                                                              configure: { [unowned self] row in
                                                                row.value = self.viewModel.correspondentAccount
                                                                row.cell.textField.placeholder = "bank_account_edit_correspondent_placeholder".loco
                                                                row.cell.textField.keyboardType = UIKeyboardType.numberPad
                                                                row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        }, onTextChanged: { [unowned self] text, value in
            self.viewModel.correspondentAccount = value
        })

        let correspondentSection = SectionFormer(rowFormer: correspondentRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_correspondent".loco))

        let settlementRow = self.createMaskedTitleFieldRow(title: nil,
                                                           primaryMaskFormat: "[000]-[00]-[000]-[0]-[0000]-[0000000]",
                                                           onValidate: { $0?.count ?? 0 == 20 },
                                                           configure: { [unowned self] row in
                                                            row.value = self.viewModel.settlementAccount

                                                            row.cell.textField.placeholder = "bank_account_edit_settlement_placeholder".loco
                                                            row.cell.textField.keyboardType = UIKeyboardType.numberPad
                                                            row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.sentences
        }, onTextChanged: { [unowned self] text, value in
            self.viewModel.settlementAccount = value
        })

        let settlementSection = SectionFormer(rowFormer: settlementRow).set(headerViewFormer: self.createHeader(text: "bank_account_edit_settlement".loco))

        former.append(sectionFormer: nameSection, bicSection, bankSection, correspondentSection, settlementSection)
    }

    // MARK: - Save

    override func cancelButtonAction(_ sender: UIBarButtonItem) {
        completion(nil)
        super.cancelButtonAction(sender)
    }

    override func onSave(success: Bool) {
        if self.isAccountNameFilled() {
            super.onSave(success: success)
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
