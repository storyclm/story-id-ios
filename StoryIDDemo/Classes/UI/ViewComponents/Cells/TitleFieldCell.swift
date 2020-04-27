//
//  TitleFieldCell.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import Former

final class TitleFieldCell: UITableViewCell, TextFieldFormableRow {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

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
