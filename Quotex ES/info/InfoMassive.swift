//
//  InfoMassive.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 12.12.2023.
//

import Foundation

class InfoMassive {
    let imageName: String
    let description: String
    let additionalInfo: String

    init(imageName: String, description: String, additionalInfo: String) {
        self.imageName = imageName
        self.description = description
        self.additionalInfo = additionalInfo
    }
}
