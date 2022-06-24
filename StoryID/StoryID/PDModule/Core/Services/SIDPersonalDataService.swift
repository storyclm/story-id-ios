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

    private init() {}

    // MARK: - PersonalServices

    public let profileDemographics = SIDProfileDemographicsService()
    public let profileItn = SIDProfileItnService()
    public let profilePasport = SIDProfilePasportService()
    public let profileSnils = SIDProfileSnilsService()
    public let profile = SIDProfileService()
    public let bankAccounts = SIDProfileBankAccountsService()
    public let avatarService = SIDProfileAvatarService()

    // MARK: - Synchronize

    public func synchronize() {
        guard isInterceptorSet() else {
            // Return or throw error
            assertionFailure("AlamofireRetrier.interceptor is nil")
            return
        }

        if profileDemographics.isSynchronizable {
            profileDemographics.synchronize { error in

            }
        }

        if profileItn.isSynchronizable {
            profileItn.synchronize { error in

            }
        }

        if profilePasport.isSynchronizable {
            profilePasport.synchronize { error in

            }
        }

        if profileSnils.isSynchronizable {
            profileSnils.synchronize { error in

            }
        }

        if profile.isSynchronizable {
            profile.synchronize { error in

            }
        }

        if bankAccounts.isSynchronizable {
            bankAccounts.synchronize { error in

            }
        }

        if avatarService.isSynchronizable {
            avatarService.synchronize { error in
                
            }
        }
    }

    // MARK: - Helpers

    func isInterceptorSet() -> Bool {
        return AlamofireRetrier.interceptor != nil
    }
}
