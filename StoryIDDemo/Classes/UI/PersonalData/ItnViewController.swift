//
//  ITNViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class ItnViewController: BaseFormViewController {

    private let viewModel = DataStorage.instance.itn ?? ItnModel(with: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "profile_itn_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        let itnRow = self.createMaskedTitleFieldRow(title: "profile_itn_number".loco,
                                                    primaryMaskFormat: "[000000000099]",
                                                    onValidate: { value in
                                                        let count = value?.count ?? 0
                                                        return count == 10 || count == 12
        }, configure: { [unowned self] row in
            row.value = self.viewModel.itn
            row.cell.textField.keyboardType = UIKeyboardType.numberPad
            row.cell.textField.placeholder = "profile_itn_number_placeholder".loco
        }) { [unowned self] text, value in
            self.viewModel.itn = value
        }

        let itnImageRow = self.createTitleImageRow(title: "profile_itn_image".loco, configure: nil, onImageRequest: { [unowned self] () -> UIImage? in
            self.viewModel.itnImage
        }, onImageSelected: { [unowned self] image in
            self.viewModel.itnImage = image
        })

        let itnSection = SectionFormer(rowFormer: itnRow, itnImageRow)
            .set(headerViewFormer: self.createHeader(text: "profile_itn_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: itnSection)
    }

    // MARK: - Save

    override func onSave() {
        super.onSave()

        let personalData = self.viewModel
        DataStorage.instance.itn = personalData

        self.navigationController?.popViewController(animated: true)
    }
}
