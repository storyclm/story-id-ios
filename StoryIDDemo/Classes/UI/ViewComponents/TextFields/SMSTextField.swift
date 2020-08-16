//
//  SMSTextField.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

final class SMSTextField: MaskTextField {

    override func commonInit() {
        validateObject = { sms in
            return sms?.count ?? 0 == 4
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        super.awakeFromNib()
        maskedDelegate.primaryMaskFormat = "[0000]"
    }

    var code: String? {
        guard let code = self.value else { return nil }
        return code
    }
}
