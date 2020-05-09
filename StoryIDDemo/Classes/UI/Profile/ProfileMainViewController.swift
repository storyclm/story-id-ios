//
//  ProfileMainViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class ProfileMainViewController: BaseFormViewController {

    override var isSaveButtonVisible: Bool { false }
    override var isCancelButtonVisible: Bool { false }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "profile_main_title".loco
    }

    // MARK: - Setup

    override func setupTableView() {
        super.setupTableView()

        // Rows
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            LabelRowFormer<FormLabelCell>(cellSetup: {
                $0.backgroundColor = UIColor.idWhite
                $0.contentView.backgroundColor = $0.backgroundColor

                $0.titleLabel.textColor = UIColor.idBlack
                $0.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
                $0.accessoryType = .disclosureIndicator
            }).configure {
                $0.text = text
            }.onSelected {[weak self] _ in
                self?.former.deselect(animated: true)
                onSelected?()
            }
        }

        let avatar = AvatarlRowFormer(cellSetup: { _ in

        }).configure {
            $0.cell.avatarView.isUserInteractionEnabled = false
            $0.rowHeight = 200.0
            $0.avatarImage = DataStorage.instance.avatarImage
        }.onSelected {[unowned self] row in
            self.former.deselect(animated: true)
            if let image = row.avatarImage {
                self.showImagePreview(image) {
                    row.avatarImage = nil
                    row.update()
                    DataStorage.instance.avatarImage = nil
                }
            } else {
                self.showImagePicker { newAvatar in
                    row.avatarImage = newAvatar
                    row.update()
                    DataStorage.instance.avatarImage = newAvatar
                }
            }
        }

        let avatarSection = SectionFormer(rowFormer: avatar)

        let demographicsRow = createMenu("profile_main_personalData_demographics".loco) { [weak self] in
            self?.navigationController?.pushViewController(DemographicsViewController(), animated: true)
        }
        let itnRow = createMenu("profile_main_personalData_itn".loco) { [weak self] in
            self?.navigationController?.pushViewController(ItnViewController(), animated: true)
        }
        let snilsRow = createMenu("profile_main_personalData_snils".loco) { [weak self] in
            self?.navigationController?.pushViewController(SnilsViewController(), animated: true)
        }
        let pasportRow = createMenu("profile_main_personalData_pasport".loco) { [weak self] in
            self?.navigationController?.pushViewController(PasportViewController(), animated: true)
        }

        let bankAccountsRow = createMenu("profile_main_bankAccount_row".loco) { [weak self] in
            self?.navigationController?.pushViewController(BankAccountListViewController(), animated: true)
        }

        let logoutRow = LabelRowFormer<FormLabelCell>(cellSetup: {
            $0.backgroundColor = UIColor.idWhite95
            $0.contentView.backgroundColor = $0.backgroundColor

            $0.titleLabel.textColor = UIColor.idRed
            $0.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
            $0.titleLabel.textAlignment = NSTextAlignment.center
        }).configure {
            $0.text = "profile_main_logout".loco
        }.onSelected {[weak self] _ in
            guard let self = self else { return }

            self.former.deselect(animated: true)

            DataStorage.instance.logout()
            AppRouter.instance.showEnterPhone(from: self)
        }

        // Create Headers and Footers

        let createHeader: ((String) -> ViewFormer) = { text in
            LabelViewFormer<FormLabelHeaderView>(viewSetup: {
                $0.backgroundColor = UIColor.idWhite
                $0.contentView.backgroundColor = $0.backgroundColor
            }).configure {
                $0.text = text
                $0.viewHeight = 40
            }
        }

        // Sections

        let personalDataSection = SectionFormer(rowFormer: demographicsRow, itnRow, snilsRow, pasportRow).set(headerViewFormer: createHeader("profile_main_personalData_section".loco))
        let bankAccauntsSection = SectionFormer(rowFormer: bankAccountsRow).set(headerViewFormer: createHeader("profile_main_bankAccount_section".loco))
        let logoutSection = SectionFormer(rowFormer: logoutRow).set(headerViewFormer: createHeader(""))

        former.append(sectionFormer: avatarSection, personalDataSection, bankAccauntsSection, logoutSection)
    }
}
