//
//  String+Ext.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 27.04.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

extension String {

    var loco: String {
        return self.loco()
    }

    func loco(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    var notEmptyValue: String? {
        let value = trimmingCharacters(in: .whitespaces)
        return value != "" ? value : nil
    }
}
