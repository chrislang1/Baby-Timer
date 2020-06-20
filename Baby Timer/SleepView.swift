//
//  SleepView.swift
//  Baby Timer
//
//  Created by Christopher Lang on 20/6/20.
//  Copyright © 2020 Christopher Lang. All rights reserved.
//

import SwiftUI
import Combine

struct SleepView: View {
    
    @ObservedObject var sleepManager = SleepManager()
    @ObservedObject var stopWatch = StopWatch()
    
    var body: some View {
        VStack(spacing: 56) {
            Spacer()
            
            VStack(spacing: 20.0) {
                Text(self.stopWatch.stopWatchTime)
                    .font(.system(size: 56, weight: .semibold, design: .monospaced))
                Text(self.sleepManager.getSleepStateDescription())
                    .font(.system(size: 17, weight: .semibold, design: .default))
            }.frame(minWidth: 0, maxWidth: .infinity)
            
            Button(action: {
                self.sleepManager.updateSleepState(timeElapsed: self.stopWatch.getElapsedTime())
                self.stopWatch.reset()
            }) {
                Text(self.sleepManager.getTimerLabelDescription())
                    .font(.system(size: 19, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .frame(width: 156, height: 156)
            }.buttonStyle(CircleButtonStyle())
            
            VStack(spacing: 8) {
                HStack {
                    Text("Today")
                        .font(.system(size: 17, weight: .medium, design: .default))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Asleep")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                    Text(self.sleepManager.getAsleepTotalString())
                        .font(.system(size: 19, weight: .semibold, design: .monospaced))
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                }
                
                HStack {
                    Text("Awake")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                    Text(self.sleepManager.getAwakeTotalString())
                        .font(.system(size: 19, weight: .semibold, design: .monospaced))
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer()
        }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            self.stopWatch.start()
        }
    }
}

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                Circle()
                    .strokeBorder(lineWidth: 2)
                    .foregroundColor(.black)
            )
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
