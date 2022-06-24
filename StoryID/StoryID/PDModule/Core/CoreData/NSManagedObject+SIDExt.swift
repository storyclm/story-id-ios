//
//  NSManager+SIDExt.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 07.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import CoreData

enum SIDDeleteConduct {
    case exclude
    case include
    case only
}

extension NSManagedObject {

    class func create<R: NSManagedObject>(userID: String? = NSManagedObject.userId) -> R {
        let result = R(context: self.context)
        if var userIdContainable = result as? SIDCoreDataUserIdContainable, let userId = userID {
            userIdContainable.userId = userId
        }
        return result
    }

    class func models<R: NSManagedObject>(userID: String? = NSManagedObject.userId, deleteConduct: SIDDeleteConduct = .exclude) -> [R]? {
        let request = NSFetchRequest<R>(entityName: String(describing: R.self))

        var predicate: NSPredicate?
        if let deletePredicate = self.deletePredicate(for: deleteConduct) {
            if let oldPredicate = predicate {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [oldPredicate, deletePredicate])
            } else {
                predicate = deletePredicate
            }
        }

        if let userId = userID {
            let userPredicate = NSPredicate(format: "userId == %@", userId)
            if let oldPredicate = predicate {
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [oldPredicate, userPredicate])
            } else {
                predicate = userPredicate
            }
        }

        request.predicate = predicate

        do {
            return try self.context.fetch(request)
        } catch {
            print("Failed to fetch \(R.self)")
            return nil
        }
    }

    class func firstModel<R: NSManagedObject>(userID: String? = NSManagedObject.userId, deleteConduct: SIDDeleteConduct = .exclude) -> R? {
        guard let result: R = self.models(userID: userID)?.first else { return nil }
        return result
    }

    func deleteModel() {
        NSManagedObject.context.delete(self)
    }

    // MARK: - Private

    private class var context: NSManagedObjectContext { SIDCoreDataManager.instance.context }
    private class var userId: String? { AlamofireRetrier.interceptor?.loader.oauth2.userSub() }

    class func deletePredicate(for conduct: SIDDeleteConduct) -> NSPredicate? {
        switch conduct {
        case .exclude: return NSPredicate(format: "isEntityDeleted == false")
        case .include: return nil
        case .only: return NSPredicate(format: "isEntityDeleted == true")
        }
    }
}
