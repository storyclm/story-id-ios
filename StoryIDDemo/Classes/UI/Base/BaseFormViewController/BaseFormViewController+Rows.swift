//
//  BaseFormViewController+Rows.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 11.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation
import Former

extension BaseFormViewController {

    func createMaskedTitleFieldRow(title: String?,
                                   primaryMaskFormat: String,
                                   affineFormats: [String]? = nil,
                                   onValidate: ((String?) -> Bool)? = nil,
                                   configure: ((MaskedTitleFieldRowFormer) -> Void)?,
                                   onTextChanged: ((String, String?) -> Void)?) -> MaskedTitleFieldRowFormer {

        MaskedTitleFieldRowFormer { cell in
            cell.backgroundColor = UIColor.idWhite95.withAlphaComponent(0.92)
            cell.contentView.backgroundColor = cell.backgroundColor

            cell.titleLabel.text = title
            cell.titleLabel.textColor = UIColor.idBlack.withAlphaComponent(0.4)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)

            cell.textField.validateObject = { value in
                return (onValidate?(value) ?? true)
            }

            cell.textField.maskedDelegate.primaryMaskFormat = primaryMaskFormat
            if let affineFormats = affineFormats {
                cell.textField.maskedDelegate.affineFormats = affineFormats
            }
        }.configure {
            configure?($0)
            $0.cell.textField.isWrongInput = true
            $0.cell.textField.checkValidation()
        }.onTextChanged { text, value in
            onTextChanged?(text, value)
        }
    }

    func createSimpleTitleFieldRow(title: String?,
                                   configure: ((SimpleTitleFieldRowFormer) -> Void)?,
                                   onTextChanged: ((String) -> Void)?) -> SimpleTitleFieldRowFormer {

        SimpleTitleFieldRowFormer { cell in
            cell.backgroundColor = UIColor.idWhite95.withAlphaComponent(0.92)
            cell.contentView.backgroundColor = cell.backgroundColor

            cell.titleLabel.text = title
            cell.titleLabel.textColor = UIColor.idBlack.withAlphaComponent(0.4)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
        }.configure {
            configure?($0)
        }.onTextChanged {
            onTextChanged?($0)
        }
    }

    func createTitleImageRow(title: String,
                             configure: ((LabelRowFormer<FormLabelCell>) -> Void)?,
                             onImageRequest: @escaping (() -> UIImage?),
                             onImageSelected: @escaping (UIImage?) -> Void) -> LabelRowFormer<FormLabelCell> {
        LabelRowFormer<FormLabelCell>(cellSetup: {
            $0.backgroundColor = UIColor.idWhite95.withAlphaComponent(0.92)
            $0.contentView.backgroundColor = $0.backgroundColor

            $0.titleLabel.textColor = UIColor.idBlack.withAlphaComponent(0.4)
            $0.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)

            $0.subTextLabel.textColor = UIColor.idRed
            $0.subTextLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)

            $0.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }).configure {
            $0.text = title
            $0.subText = onImageRequest() != nil ? "profile_image_change".loco : "profile_image_add".loco
            configure?($0)
        }.onSelected { [weak self] row in
            self?.former.deselect(animated: true)
            guard let self = self else { return }

            if let image = onImageRequest() {
                self.showImagePreview(image) {
                    row.subText = "profile_image_add".loco
                    row.update()
                    onImageSelected(nil)
                }
            } else {
                self.showImagePicker { image in
                    row.subText = image != nil ? "profile_image_change".loco : "profile_image_add".loco
                    row.update()
                    onImageSelected(image)
                }
            }
        }
    }

    func createMenuRow(text: String?, onSelected: @escaping () -> Void) -> RowFormer {
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
            onSelected()
        }
    }

    func createLabelRow(text: String, subText: String?) -> RowFormer {
        LabelRowFormer<FormLabelCell>(cellSetup: {
            $0.backgroundColor = UIColor.idWhite
            $0.contentView.backgroundColor = $0.backgroundColor

            $0.titleLabel.textColor = UIColor.idBlack
            $0.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)

            $0.subTextLabel.textColor = UIColor.idGrey
            $0.subTextLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        }).configure {
            $0.text = text
            $0.subText = subText
        }
    }

    func createHeader(text: String) -> LabelViewFormer<FormLabelHeaderView> {
        LabelViewFormer<FormLabelHeaderView>(viewSetup: {
            $0.backgroundColor = UIColor.idWhite
            $0.contentView.backgroundColor = $0.backgroundColor
        }).configure {
            $0.text = text
            $0.viewHeight = 40.0
        }
    }

    func createFooter(text: String) -> LabelViewFormer<FormLabelFooterView> {
        LabelViewFormer<FormLabelFooterView>(viewSetup: {
            $0.backgroundColor = UIColor.idWhite
            $0.contentView.backgroundColor = $0.backgroundColor

            $0.titleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
            $0.titleLabel.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 1.0)
        }).configure {
            $0.text = text
            $0.viewHeight = 45
        }
    }

    func createButton(text: String, onSelected: @escaping () -> Void) -> RowFormer {
        return LabelRowFormer<FormLabelCell>(cellSetup: {
            $0.backgroundColor = UIColor.idWhite95
            $0.contentView.backgroundColor = $0.backgroundColor

            $0.titleLabel.textColor = UIColor.idRed
            $0.titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
            $0.titleLabel.textAlignment = NSTextAlignment.center
        }).configure {
            $0.text = text
        }.onSelected {[weak self] _ in
            self?.former.deselect(animated: true)
            onSelected()
        }
    }

    // MARK: - Images

    func showImagePicker(completion: @escaping (UIImage?) -> Void) {
        self.imagePicker.pickImage(from: self, isDeleteAvailable: false, onDeleteImage: {
            completion(nil)
        }) { image in
            completion(image)
        }
    }

    func showImagePreview(_ image: UIImage, onDelete: @escaping () -> Void) {
        self.imagePreview.show(images: [image], from: self, onDeleteAction: { browser, _ in
            browser.dismiss(animated: true, completion: nil)
            onDelete()
        })
    }
    
}
