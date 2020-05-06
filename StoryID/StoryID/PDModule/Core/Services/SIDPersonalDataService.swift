//
//  SIDPersonalDataService.swift
//  StoryID
//
//  Created by Sergey Ryazanov on 05.05.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import Foundation

public final class SIDPersonalDataService {

    public static let instance = SIDPersonalDataService()

    public private(set) var isSynchronized = false

    private init() {}

    // MARK: - PersonalServices

    public let profileDemographics = SIDProfileDemographicsService()
    public let profileItn = SIDProfileItnService()
    public let profilePasport = SIDProfilePasportService()
    public let profileSnils = SIDProfileSnilsService()
    public let profile = SIDProfileService()

    // MARK: - Synchronize

    public func synchronize() {
        guard isRetrierSet() else {
            // Return or throw error
            assertionFailure("AlamofireRetrier.retrier is nil")
            return
        }

        guard isSynchronized == false else { return }
        self.isSynchronized = true

        let group = DispatchGroup()

        if profileDemographics.isSynchronizable {
            group.enter()
            profileDemographics.synchronize { error in
                group.leave()
            }
        }

        if profileItn.isSynchronizable {
            group.enter()
            profileItn.synchronize { error in
                group.leave()
            }
        }

        if profilePasport.isSynchronizable {
            group.enter()
            profilePasport.synchronize { error in
                group.leave()
            }
        }

        if profileSnils.isSynchronizable {
            group.enter()
            profileSnils.synchronize { error in
                group.leave()
            }
        }

        if profile.isSynchronizable {
            group.enter()
            profile.synchronize { error in
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) { [unowned self] in
            self.isSynchronized = false
        }
    }

    // MARK: - Helpers

    func isRetrierSet() -> Bool {
        return AlamofireRetrier.retrier != nil
    }
}
