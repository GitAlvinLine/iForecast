//
//  RemoteDailyAstronomyLoader.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/18/23.
//

import Foundation

public final class RemoteDailyAstronomyLoader: DailyAstronomyLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = DailyAstronomyResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(AstronomyItemMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
