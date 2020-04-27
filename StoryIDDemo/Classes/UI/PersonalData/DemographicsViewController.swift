//
//  DemographicsViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class DemographicsViewController: BaseViewController {

    private let viewModel = DataStorage.instance.demographics ?? DemographicsModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "profile_demographics_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        let surnameRow = self.createTitleFieldRow(title: "profile_demographics_surname".loco, configure: {[unowned self] cell in
            cell.text = self.viewModel.surname
        }, onTextChanged: {[unowned self] surname in
            self.viewModel.surname = surname
        })

        let nameRow = self.createTitleFieldRow(title: "profile_demographics_name".loco, configure: {[unowned self] cell in
            cell.text = self.viewModel.name
        }, onTextChanged: {[unowned self] name in
            self.viewModel.name = name
        })

        let patronymicRow = self.createTitleFieldRow(title: "profile_demographics_patronymic".loco, configure: {[unowned self] cell in
            cell.text = self.viewModel.patronymic
        }, onTextChanged: {[unowned self] patronymic in
            self.viewModel.patronymic = patronymic
        })

        let phoneNumberRow = self.createTitleFieldRow(title: "profile_demographics_phone_number".loco, configure: {[unowned self] cell in
            cell.text = self.viewModel.phoneNumber
        }, onTextChanged: {[unowned self] phone in
            self.viewModel.phoneNumber = phone
        })

        let emailRow = self.createTitleFieldRow(title: "profile_demographics_email".loco, configure: {[unowned self] cell in
            cell.text = self.viewModel.email
        }, onTextChanged: {[unowned self] email in
            self.viewModel.email = email
        })

        let demographicsSection = SectionFormer(rowFormer: surnameRow, nameRow, patronymicRow, phoneNumberRow, emailRow)
            .set(headerViewFormer: self.createHeader(text: "profile_demographics_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: demographicsSection)
    }

    // MARK: - Save

    override func onSave() {
        super.onSave()

        let personalData = self.viewModel
        DataStorage.instance.demographics = personalData

        self.navigationController?.popViewController(animated: true)
    }
}
