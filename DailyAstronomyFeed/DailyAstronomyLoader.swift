//
//  DailyAstronomyLoader.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/14/23.
//

import Foundation

enum DailyAstronomyResult {
    case success(AstronomyItem)
    case failure(Error)
}

protocol DailyAstronomyLoader {
    func load(completion: @escaping (DailyAstronomyResult) -> Void)
}
