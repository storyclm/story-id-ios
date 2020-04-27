//
//  PaddedTextField.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {
    
    var padding: UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: clearButtonMode == .whileEditing || clearButtonMode == .always ? 20 : 15)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

class PaddedClearButtonTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = super.clearButtonRect(forBounds: bounds)
        return bounds.inset(by: padding)
    }
}
