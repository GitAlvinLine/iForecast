//
//  AstronomyItem.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/14/23.
//

import Foundation

public struct AstronomyItem: Equatable {
    let copyright: String
    let date: String
    let explanation: String
    let imageURL: URL
    let title: String
}
