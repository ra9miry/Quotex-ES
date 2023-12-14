//
//  Crypto.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 14.12.2023.
//

import Foundation

struct Cryptocurrency: Codable{
    let name: String
    let coinPrice: Double
    let purchasePrice: Double
    let quantity: Double
    let purchaseDate: Date

    init(name: String, coinPrice: Double, purchasePrice: Double, quantity: Double, purchaseDate: Date, imageName: String) {
        self.name = name
        self.coinPrice = coinPrice
        self.purchasePrice = purchasePrice
        self.quantity = quantity
        self.purchaseDate = purchaseDate
    }
}
