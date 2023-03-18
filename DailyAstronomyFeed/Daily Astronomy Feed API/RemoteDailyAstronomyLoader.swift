//
//  RemoteDailyAstronomyLoader.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/18/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteDailyAstronomyLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
