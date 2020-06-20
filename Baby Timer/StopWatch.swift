//
//  StopWatch.swift
//  Baby Timer
//
//  Created by Christopher Lang on 20/6/20.
//  Copyright © 2020 Christopher Lang. All rights reserved.
//

import Foundation
import Combine

class StopWatch: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private let queue = DispatchQueue(label: "stopwatch.timer")
    private var counter: Int = 0
    
    var stopWatchTime = "00:00.00" {
        didSet {
            self.update()
        }
    }
    
    func start() {
        guard let _ = self.sourceTimer else {
            self.startTimer()
            return
        }
        
        self.resumeTimer()
    }
    
    private func startTimer() {
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                          queue: self.queue)
        
        self.resumeTimer()
    }
    
    private func resumeTimer() {
        self.sourceTimer?.setEventHandler {
            self.updateTimer()
        }
        
        self.sourceTimer?.schedule(deadline: .now(),
                                   repeating: 0.01)
        self.sourceTimer?.resume()
    }
    
    func reset() {
        self.stopWatchTime = "00:00.00"
        self.counter = 0
    }
    
    private func updateTimer() {
        self.counter += 1
        
        DispatchQueue.main.async {
            if self.counter.msToSeconds < 3600 {
                self.stopWatchTime = self.counter.msToSeconds.minuteSecondMS
            } else {
                self.stopWatchTime = self.counter.msToSeconds.hourMinuteSecondMS
            }
        }
    }
    
    func getElapsedTime() -> Int {
        return counter
    }
    
    func update() {
        objectWillChange.send()
    }
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%02d:%02d.%02d", minute, second, millisecond)
    }
    
    var hourMinuteSecondMS: String {
        return String(format:"%d:%02d:%02d", hour, minute, second, millisecond)
    }
    
    var hour: Int {
        return Int((self/3600).truncatingRemainder(dividingBy: 60))
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*100).truncatingRemainder(dividingBy: 100))
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 100
    }
}
