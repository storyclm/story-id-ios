//
//  PasportViewController.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Former

final class PasportViewController: BaseFormViewController {

    private var viewModel: PasportModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "profile_pasport_title".loco
    }

    // MARK: - View model

    override internal func loadViewModel() {
        DataStorage.instance.pasport { [weak self] pasportModel in
            self?.viewModel = pasportModel
            self?.completeLoadViewModel()
        }
    }

    override func setupTableView() {
        super.setupTableView()

        let pasportRow = self.createMaskedTitleFieldRow(title: "profile_pasport_number".loco,
                                                        primaryMaskFormat: "[00] [00] [000000]",
                                                        onValidate: { $0?.count ?? 0 == 10 },
                                                        configure: { [unowned self] row in
                                                            row.value = self.viewModel?.sn
                                                            row.cell.textField.keyboardType = UIKeyboardType.numberPad
                                                            row.cell.textField.placeholder = "profile_pasport_number_placeholder".loco
                                                        }, onTextChanged: { [unowned self] text, value in
                                                            self.viewModel?.sn = value
                                                        })

        let pasportFirstImageRow = self.createTitleImageRow(title: "profile_pasport_first_image".loco, configure: nil, onImageRequest: { [unowned self] () -> UIImage? in
            return self.viewModel?.firstImage
        }, onImageSelected: { [unowned self] image in
            self.viewModel?.firstImage = image
        })

        let pasportSecondImageRow = self.createTitleImageRow(title: "profile_pasport_second_image".loco, configure: nil, onImageRequest: { [unowned self] () -> UIImage? in
            return self.viewModel?.secondImage
        }, onImageSelected: { [unowned self] image in
            self.viewModel?.secondImage = image
        })

        let pasportSection = SectionFormer(rowFormer: pasportRow, pasportFirstImageRow, pasportSecondImageRow)
            .set(headerViewFormer: self.createHeader(text: "profile_pasport_section".loco))
            .set(footerViewFormer: self.createFooter(text: "profile_data_info_hint".loco))

        former.append(sectionFormer: pasportSection)
        former.reload()
    }

    // MARK: - Save

    override func onSave(success: Bool) {
        super.onSave(success: isLoadViewModelCompleted)

        if success {
            let personalData = self.viewModel
            DataStorage.instance.setPasport(personalData)
        }

        self.navigationController?.popViewController(animated: true)
    }
}
