//
//  DailyAstronomyLoader.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/14/23.
//

import Foundation

public enum DailyAstronomyResult<Error: Swift.Error> {
    case success(AstronomyItem)
    case failure(Error)
}

public protocol DailyAstronomyLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (DailyAstronomyResult<Error>) -> Void)
}
