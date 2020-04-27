//
//  SnilsViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class SnilsViewController: BaseViewController {

    private let viewModel = DataStorage.instance.snils ?? SnilsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "profile_snils_title".loco
    }

    override func setupTableView() {
        super.setupTableView()

        let snilsRow = self.createTitleFieldRow(title: "profile_snils_number".loco, configure: { [unowned self] row in
            row.text = self.viewModel.snils
        }, onTextChanged: { [unowned self] snils in
            self.viewModel.snils = snils
        })

        let snilsImageRow = self.createTitleImageRow(title: "profile_snils_image".loco, configure: nil, onImageRequest: { [unowned self] () -> UIImage? in
            self.viewModel.snilsImage
        }, onImageSelected: { [unowned self] image in
            self.viewModel.snilsImage = image
        })

        let snilsSection = SectionFormer(rowFormer: snilsRow, snilsImageRow)
            .set(headerViewFormer: self.createHeader(text: "profile_snils_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: snilsSection)
    }

    // MARK: - Save

    override func onSave() {
        super.onSave()

        let personalData = self.viewModel
        DataStorage.instance.snils = personalData

        self.navigationController?.popViewController(animated: true)
    }
}
