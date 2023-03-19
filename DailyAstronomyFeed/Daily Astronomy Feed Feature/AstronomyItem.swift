//
//  AstronomyItem.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/14/23.
//

import Foundation

public struct AstronomyItem: Equatable {
    public let date: String
    public let explanation: String
    public let title: String
    public let imageURL: URL
    
    public init(date: String, explanation: String, title: String, imageURL: URL) {
        self.date = date
        self.explanation = explanation
        self.title = title
        self.imageURL = imageURL
    }
}
