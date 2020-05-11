//
//  MaskedTitleFieldCell.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import Former

final class MaskedTitleFieldCell: UITableViewCell, TextFieldFormableRow {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: MaskTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor.init(white: 1.0, alpha: 0.4)
        textField.textColor = UIColor.idBlack
    }

    func formTextField() -> UITextField {
        return textField
    }

    func formTitleLabel() -> UILabel? {
        return titleLabel
    }

    func updateWithRowFormer(_ rowFormer: RowFormer) {}

}

class MaskedTitleFieldRowFormer: BaseRowFormer<MaskedTitleFieldCell>, Formable {

    // MARK: Public

    public var text: String? {
        didSet {
            self.cell.textField.text = self.text
        }
    }
    public var value: String? {
        didSet {
            self.cell.textField.value = self.value
        }
    }

    public final func onTextChanged(handler: @escaping ((String, String?) -> Void)) -> Self {
        self.onTextChanged = handler
        return self
    }

    public required init(instantiateType: Former.InstantiateType = .Nib(nibName: "MaskedTitleFieldCell"), cellSetup: ((MaskedTitleFieldCell) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }

    override var canBecomeEditing: Bool {
        return self.cell.textField.isEnabled
    }

    override func cellInitialized(_ cell: MaskedTitleFieldCell) {
        super.cellInitialized(cell)

        cell.textField.addTarget(self, action: #selector(onTextFieldChanged(textField:)), for: UIControl.Event.editingChanged)
    }

    override func update() {
        super.update()

        self.cell.selectionStyle = .none
        if let value = self.value {
            self.cell.textField.value = value
        } else if let text = self.text {
            self.cell.textField.text = text
        }
    }

    // MARK: - Action

    @objc private func onTextFieldChanged(textField: MaskTextField) {
        if enabled {
            let value = textField.value
            let text = value ?? ""

            self.text = text
            self.value = value
            onTextChanged?(text, value)
        }
    }

    // MARK: - Private

    private final var onTextChanged: ((String, String?) -> Void)?

}
