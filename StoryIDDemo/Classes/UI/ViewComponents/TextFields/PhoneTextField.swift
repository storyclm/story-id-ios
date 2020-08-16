//
//  PhoneTextField.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import InputMask

class PhoneTextField: MaskTextField {
    
    override func commonInit() {
        validateObject = { (phone) in
            return phone?.count ?? 0 == 10
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

    func setup() {
        super.awakeFromNib()
        
        maskedDelegate.primaryMaskFormat = "+7 ([000]) [000]-[00]-[00]"
        maskedDelegate.affineFormats = ["8 ([000]) [000]-[00]-[00]"]
    }

    var phone: String? {
        if let value = value {
            return "7\(value)"
        }
        return nil
    }
}
