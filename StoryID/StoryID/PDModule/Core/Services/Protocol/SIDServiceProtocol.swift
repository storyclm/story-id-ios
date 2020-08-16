//
//  SIDServiceProtocol.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

public protocol SIDServiceProtocol {
    func synchronize(completion: @escaping SIDServiceHelper.SynchronizeBlock)
    var isSynchronizable: Bool { get set }
}
