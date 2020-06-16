//
//  SIDObserveManager.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 16.06.2020.
//

import Foundation

public final class SIDObserveManager {

    public final class SIDObserver {
        public enum ObserveType {
            case model
            case image
            case both
        }

        public var type: ObserveType = ObserveType.both
        public var callback: ((AnyObject?) -> Void)

        init(type: ObserveType, callback: @escaping (AnyObject?) -> Void) {
            self.type = type
            self.callback = callback
        }
    }

    private let mapTable = NSMapTable<AnyObject, SIDObserver>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

    // MARK: -

    public func addObserver(_ observer: AnyObject, type: SIDObserver.ObserveType, callback: @escaping ((AnyObject?) -> Void)) {
        self.removeObserver(observer)

        let value = SIDObserver(type: type, callback: callback)
        self.mapTable.setObject(value, forKey: observer)
    }

    public func removeObserver(_ observer: AnyObject) {
        self.mapTable.removeObject(forKey: observer)
    }

    public func allObserver(with type: SIDObserver.ObserveType) -> [(key: AnyObject, value: SIDObserver)] {
        var result: [(key: AnyObject, value: SIDObserver)] = []

        for object in self.mapTable.keyEnumerator().allObjects {
            guard let value = self.mapTable.object(forKey: object as AnyObject) else { continue }

            if value.type == .both || value.type == type {
                result.append((key: object  as AnyObject, value: value))
            }
        }

        return result
    }
}

extension SIDObserveManager {
    subscript(key: AnyObject) -> SIDObserver? {
        get { return self.mapTable.object(forKey: key) }
        set {
            if let newValue = newValue {
                self.mapTable.setObject(newValue, forKey: key)
            } else {
                self.mapTable.removeObject(forKey: key)
            }
        }
    }
}
