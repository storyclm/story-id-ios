//
//  SimpleTitleFieldCell.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import Former

final class SimpleTitleFieldCell: UITableViewCell, TextFieldFormableRow {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!

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

class SimpleTitleFieldRowFormer: BaseRowFormer<SimpleTitleFieldCell>, Formable {

    // MARK: Public

    public var text: String? {
        didSet {
            self.cell.textField.text = self.text
        }
    }

    public final func onTextChanged(handler: @escaping ((String) -> Void)) -> Self {
        self.onTextChanged = handler
        return self
    }

    public required init(instantiateType: Former.InstantiateType = .Nib(nibName: "SimpleTitleFieldCell"), cellSetup: ((SimpleTitleFieldCell) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }

    override var canBecomeEditing: Bool {
        return self.cell.textField.isEnabled
    }

    override func cellInitialized(_ cell: SimpleTitleFieldCell) {
        super.cellInitialized(cell)

        cell.textField.addTarget(self, action: #selector(onTextFieldChanged(textField:)), for: UIControl.Event.editingChanged)
    }

    override func update() {
        super.update()

        self.cell.selectionStyle = .none
        self.cell.textField.text = text
    }

    // MARK: - Action

    @objc private func onTextFieldChanged(textField: UITextField) {
        if enabled {
            let text = textField.text ?? ""

            self.text = text
            onTextChanged?(text)
        }
    }

    // MARK: - Private

    private final var onTextChanged: ((String) -> Void)?

}
