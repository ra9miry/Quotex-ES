//
//  PortfolioData.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 23.12.2023.
//

import Foundation

class PortfolioData {
    static let shared = PortfolioData()

    var hourPercentage: String = ""
    var dayPercentage: String = ""
    var weekPercentage: String = ""

    private var updateTimer: Timer?

    init() {
        startUpdatingEveryMinute()
    }

    private func startUpdatingEveryMinute() {
        updateTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updatePercentages), userInfo: nil, repeats: true)
        updateTimer?.fire()
    }

    @objc private func updatePercentages() {
        let hour = Double.random(in: 0...100).rounded(toPlaces: 2)
        let day = Double.random(in: 0...100).rounded(toPlaces: 2)
        let week = Double.random(in: 0...100).rounded(toPlaces: 2)

        hourPercentage = String(format: "+%.2f%%", hour)
        dayPercentage = String(format: "+%.2f%%", day)
        weekPercentage = String(format: "+%.2f%%", week)
        NotificationCenter.default.post(name: NSNotification.Name("PortfolioDataUpdated"), object: nil)
    }
    
    deinit {
        updateTimer?.invalidate()
    }
}
