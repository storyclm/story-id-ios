//
//  BankAccountListViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class BankAccountListViewController: BaseFormViewController {

    private var viewModel = DataStorage.instance.bankAccounts ?? [BankAccountModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "bank_accounts_list_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        former.append(sectionFormer: self.accountSection())

        let createAccountRow = self.createButton(text: "bank_accounts_list_add_account_text".loco) {
            self.openAccount(nil)
        }
        let createAccountSection = SectionFormer(rowFormer: createAccountRow)
            .set(headerViewFormer: self.createHeader(text: "bank_accounts_list_add_account_section".loco))

        former.append(sectionFormer: createAccountSection)
    }

    func accountSection() -> SectionFormer {
        if self.viewModel.isEmpty {
            let emptyRow = self.createLabelRow(text: "bank_accounts_list_section_empty".loco, subText: nil)
            let accountSection = SectionFormer(rowFormer: emptyRow).set(headerViewFormer: self.createHeader(text: "bank_accounts_list_section".loco))
            return accountSection
        } else {
            var rows: [RowFormer] = []
            for model in self.viewModel {
                let row = self.createMenuRow(text: model.accountName) {
                    self.openAccount(model)
                }
                rows.append(row)
            }

            let accountSection = SectionFormer(rowFormers: rows).set(headerViewFormer: self.createHeader(text: "bank_accounts_list_section".loco))
            return accountSection
        }
    }

    // MARK: -

    private func openAccount(_ model: BankAccountModel?) {
        let accountViewController = BankAccountEditViewController(viewModel: model) { newModel in
            self.replaceModel(model: model, with: newModel)
        }
        self.navigationController?.pushViewController(accountViewController, animated: true)
    }

    private func replaceModel(model: BankAccountModel?, with newModel: BankAccountModel?) {
        guard let newModel = newModel else { return }
        
        if let model = model {
            if let idx = self.deleteModel(model), newModel.isEmpty == false {
                self.viewModel.insert(newModel, at: idx)
            }
        } else {
            if newModel.isEmpty == false {
                self.viewModel.append(newModel)
            }
        }
        self.reloadAccount()
    }

    @discardableResult
    private func deleteModel(_ model: BankAccountModel) -> Int? {
        guard let idx = self.viewModel.firstIndex(where: { $0.uuid == model.uuid }) else { return nil }
        self.viewModel.remove(at: idx)
        return idx
    }

    private func reloadAccount() {
        if let accountSection = former.sectionFormers.first {
            former.removeUpdate(sectionFormer: accountSection, rowAnimation: UITableView.RowAnimation.right)
            former.insertUpdate(sectionFormer: self.accountSection(), toSection: 0, rowAnimation: UITableView.RowAnimation.left)
//            former.reload()
        }
    }

    // MARK: - Save

    override var isSaveButtonVisible: Bool { false }

    @objc override func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.onSave()
        super.cancelButtonAction(sender)
    }

    override func onSave() {
        super.onSave()

        let viewModel = self.viewModel
        DataStorage.instance.bankAccounts = viewModel
    }
}
