//
//  SleepManager.swift
//  Baby Timer
//
//  Created by Christopher Lang on 20/6/20.
//  Copyright © 2020 Christopher Lang. All rights reserved.
//

import Foundation
import Combine

enum SleepState {
    case asleep
    case awake
    
    var description: String {
        switch self {
        case .asleep: return "Asleep"
        case .awake: return "Awake"
        }
    }
    
    var oppositeDescription: String {
        switch self {
        case .asleep: return "Awake"
        case .awake: return "Asleep"
        }
    }
    
    func toggle() -> SleepState {
        switch self {
        case .asleep: return .awake
        case .awake: return .asleep
        }
    }
}

class SleepManager: ObservableObject {
    var currentSleepState: SleepState = .awake
    var asleepTotal: Int = 0
    var awakeTotal: Int = 0
    
    func getSleepStateDescription() -> String {
        return currentSleepState.description
    }
    
    func getTimerLabelDescription() -> String {
        return currentSleepState.oppositeDescription
    }
    
    func updateSleepState(timeElapsed: Int) {
        self.updateSleepTotal(forSleepState: self.currentSleepState, amount: timeElapsed)
        self.currentSleepState = self.currentSleepState.toggle()
        objectWillChange.send()
    }
    
    func updateSleepTotal(forSleepState state: SleepState, amount: Int) {
        switch state {
        case .asleep: asleepTotal += amount
        case .awake: awakeTotal += amount
        }
    }
    
    func getAsleepTotalString() -> String {
        if asleepTotal.msToSeconds < 3600 {
            return asleepTotal.msToSeconds.minuteSecondMS
        } else {
            return asleepTotal.msToSeconds.hourMinuteSecondMS
        }
    }
    
    func getAwakeTotalString() -> String {
        if awakeTotal.msToSeconds < 3600 {
            return awakeTotal.msToSeconds.minuteSecondMS
        } else {
            return awakeTotal.msToSeconds.hourMinuteSecondMS
        }
    }
}
