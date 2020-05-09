//
//  MaskTextField.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit
import InputMask

class MaskTextField: TextField {

    override var validatedObject: String? {
        return _value
    }
    
    let maskedDelegate = MaskedTextFieldDelegate()
    
    private var _value: String?
    override var value: String? {
        get { return _value?.notEmptyValue }
        set {
            _value = nil
            if let newValue = newValue {
                maskedDelegate.put(text: newValue, into: self)
            } else {
                text = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        maskedDelegate.delegate = self
        maskedDelegate.affinityCalculationStrategy = .prefix
        delegate = maskedDelegate
    }
}

extension MaskTextField: MaskedTextFieldDelegateListener {
    
    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        
        let idChanged = _value != nil && _value != value
        _value = value
        
        if idChanged {
            sendActions(for: .editingChanged)
        }
        
        checkValidation()
    }
}
