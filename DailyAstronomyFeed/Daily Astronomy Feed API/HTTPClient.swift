//
//  HTTPClient.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/19/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
