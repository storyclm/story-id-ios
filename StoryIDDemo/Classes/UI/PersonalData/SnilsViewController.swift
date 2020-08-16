//
//  SnilsViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class SnilsViewController: BaseFormViewController {

    private var viewModel: SnilsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "profile_snils_title".loco
    }

    override func loadViewModel() {
        DataStorage.instance.snils {[weak self] snilsModel in
            self?.viewModel = snilsModel
            self?.completeLoadViewModel()
        }
    }

    override func setupTableView() {
        super.setupTableView()
        
        let snilsRow = self.createMaskedTitleFieldRow(title: "profile_snils_number".loco,
                                                      primaryMaskFormat: "[000]-[000]-[000] [00]",
                                                      onValidate: {
                                                        $0?.count ?? 0 == 11

        }, configure: { [unowned self] row in
            row.value = self.viewModel?.snils
            row.cell.textField.keyboardType = UIKeyboardType.numberPad
            row.cell.textField.placeholder = "profile_snils_number_placeholder".loco
        }, onTextChanged: { [unowned self] text, value in
            self.viewModel?.snils = value
        })
        
        let snilsImageRow = self.createTitleImageRow(title: "profile_snils_image".loco,
                                                     configure: nil,
                                                     onImageRequest: { [unowned self] () -> UIImage? in
                                                        return self.viewModel?.snilsImage
        }, onImageSelected: { [unowned self] image in
            self.viewModel?.snilsImage = image
        })

        let snilsSection = SectionFormer(rowFormer: snilsRow, snilsImageRow)
            .set(headerViewFormer: self.createHeader(text: "profile_snils_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: snilsSection)
        former.reload()
    }

    // MARK: - Save

    override func onSave(success: Bool) {
        super.onSave(success: success)

        if success {
            let snilsModel = self.viewModel
            DataStorage.instance.setSnils(snilsModel)
        }

        self.navigationController?.popViewController(animated: true)
    }
}
