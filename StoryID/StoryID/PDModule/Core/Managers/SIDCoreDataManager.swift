//
//  SIDCoreDataManager.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import CoreData

public final class SIDCoreDataManager {

    public static let instance = SIDCoreDataManager()

    public lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: type(of: self))
        guard let momUrl = bundle.url(forResource: "sidpd", withExtension: "momd") else {
            fatalError("Error loading mom")
        }

        guard let mom = NSManagedObjectModel(contentsOf: momUrl) else {
            fatalError("Error loading model")
        }

        let container = NSPersistentContainer(name: "sidpd", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() {}

    // MARK: -

    public func saveContext() {
        let context = self.context

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                let message = "[SIDCoreDataManager] saveContext error: \(nserror) - \(nserror.localizedDescription)"
                assertionFailure(message)
            }
        }
    }
}
