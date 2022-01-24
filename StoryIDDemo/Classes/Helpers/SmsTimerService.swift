//
//  SmsTimerService.swift
//  StoryIDDemo
//
//  Created by Sergey Ryazanov on 04.06.2020.
//  Copyright © 2020 breffi. All rights reserved.
//

import UIKit

// MARK: - SmsTimerServiceDelegate

protocol SmsTimerServiceDelegate: AnyObject {
    func timerFired(_ timerService: SmsTimerService, seconds: Int)
    func timedDone(_ timerService: SmsTimerService)
}

// MARK: - SmsTimerService

final class SmsTimerService {
    public static var DefaultInterval = 90

    weak var delegate: SmsTimerServiceDelegate?

    static let instance = SmsTimerService()

    public var isTimerActive: Bool { self.timer.isValid }

    private(set) var phone = ""
    private(set) var timer = Timer()
    private var startTime: Double = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(callFireDelegate), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Actions

    @objc private func fireAction(_ timer: Timer) {
        self.callFireDelegate()

        if startTime + Double(SmsTimerService.DefaultInterval) <= Date().timeIntervalSince1970 {
            stopTimer()
            self.delegate?.timedDone(self)
        }
    }

    @objc func callFireDelegate() {
        if isTimerActive {
            self.delegate?.timerFired(self, seconds: self.seconds)
        } else {
            self.delegate?.timedDone(self)
        }
    }

    // MARK: - Start / Stop

    func startTimer(phone: String) {
        self.phone = phone
        self.stopTimer()

        if timer.isValid == false {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireAction(_:)), userInfo: nil, repeats: true)
            self.startTime = Date().timeIntervalSince1970
        }

        self.callFireDelegate()
    }

    public func stopTimer() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    // MARK: - Seconds

    var seconds: Int {
        let sec = SmsTimerService.DefaultInterval - Int((Date().timeIntervalSince1970 - startTime).rounded(.down))
        guard sec >= 0 else { return 0 }
        return sec
    }

    // MARK: - Phone

    public func isPhoneEqual(_ phone: String) -> Bool {
        return self.phone == phone
    }
}
