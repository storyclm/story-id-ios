//
//  TextField.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

// MARK: - ValidatedField

protocol ValidatedField {

    associatedtype ValidatedType

    var validateObject: ((_ object: ValidatedType) -> Bool)? { get set }
    var updateValidState: ((_ object: ValidatedType, _ isValid: Bool) -> Void)? { get set }

    var isWrongInput: Bool { get set }

    var validatedObject: ValidatedType { get }
}

extension ValidatedField {

    @discardableResult
    func checkValidation() -> Bool {
        let check = validateObject?(validatedObject) ?? true
        if let updateValidState = updateValidState, isWrongInput {
            updateValidState(validatedObject, check)
        }
        return check
    }

    func resetWrongState() -> Bool {
        if isWrongInput {
            updateValidState?(validatedObject, true)
        }
        return false
    }
}

// MARK: - TextField

class TextField: PaddedTextField, ValidatedField {

    typealias ValidatedType = String?

    var validatedObject: String? {
        return text
    }

    var validateObject: ((_ object: String?) -> Bool)?
    var updateValidState: ((_ text: String?, _ isValid: Bool) -> Void)?

    var shouldReturn: (() -> Void)?

    var value: String? {
        get { return text?.notEmptyValue }
        set { text = newValue }
    }

    var isWrongInput = false

    var textFieldShouldChangeCharactersIn: ((_ range: NSRange, _ string: String) -> Bool)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        validateObject = { obj in
            return obj?.notEmptyValue != nil
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        checkValidation()
    }
}

// MARK: UITextFieldDelegate

extension TextField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWrongInput = true
        shouldReturn?()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldShouldChangeCharactersIn?(range, string) ?? true
    }
}
