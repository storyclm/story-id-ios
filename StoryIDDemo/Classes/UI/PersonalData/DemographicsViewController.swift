//
//  DemographicsViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former
final class DemographicsViewController: BaseFormViewController {

    private let viewModel = DataStorage.instance.demographics ?? DemographicsModel(with: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "profile_demographics_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        let surnameRow = self.createMaskedTitleFieldRow(title: "profile_demographics_surname".loco,
                                                        primaryMaskFormat: "[AA…]",
                                                        onValidate: {
                                                            $0?.count ?? 0 >= 2
                                                        }, configure: { [unowned self] row in
                                                            row.value = self.viewModel.surname
                                                            row.cell.textField.placeholder = "profile_demographics_surname_placeholder".loco
                                                            row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.words
                                                        }, onTextChanged: { [unowned self] text, value in
                                                            self.viewModel.surname = value
                                                        })

        let nameRow = self.createMaskedTitleFieldRow(title: "profile_demographics_name".loco,
                                                     primaryMaskFormat: "[AA…]",
                                                     onValidate: {
                                                         $0?.count ?? 0 >= 2
                                                     }, configure: { [unowned self] row in
                                                         row.value = self.viewModel.name
                                                         row.cell.textField.placeholder = "profile_demographics_name_placeholder".loco
                                                         row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.words
                                                     }, onTextChanged: { [unowned self] text, value in
                                                         self.viewModel.name = value
                                                     })

        let patronymicRow = self.createMaskedTitleFieldRow(title: "profile_demographics_patronymic".loco,
                                                           primaryMaskFormat: "[AA…]",
                                                           onValidate: {
                                                               $0?.count ?? 0 >= 2
                                                           }, configure: { [unowned self] row in
                                                               row.value = self.viewModel.patronymic
                                                               row.cell.textField.placeholder = "profile_demographics_patronymic_placeholder".loco
                                                               row.cell.textField.autocapitalizationType = UITextAutocapitalizationType.words
                                                           }, onTextChanged: { [unowned self] text, value in
                                                               self.viewModel.patronymic = value
                                                           })

        let demographicsSection = SectionFormer(rowFormer: surnameRow, nameRow, patronymicRow)
            .set(headerViewFormer: self.createHeader(text: "profile_demographics_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: demographicsSection)
        former.reload()
    }

    // MARK: - Save

    override func onSave(success: Bool) {
        super.onSave(success: success)

        if success {
            let demographicsModel = self.viewModel
            DataStorage.instance.demographics = demographicsModel
        }

        self.navigationController?.popViewController(animated: true)
    }
}
