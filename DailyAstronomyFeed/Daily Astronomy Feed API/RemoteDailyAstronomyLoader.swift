//
//  RemoteDailyAstronomyLoader.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/18/23.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteDailyAstronomyLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(AstronomyItem)
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                if let astronomyItem = try? AstronomyItemMapper.map(data,response) {
                    completion(.success(astronomyItem))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private enum AstronomyItemMapper {
    
    private struct Item: Decodable {
        public let date: String
        public let explanation: String
        public let title: String
        public let url: URL
        
        var astronomyItem: AstronomyItem {
            return AstronomyItem(date: date,
                                 explanation: explanation,
                                 title: title,
                                 imageURL: url)
        }
    }
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> AstronomyItem {
        guard response.statusCode == OK_200 else {
            throw RemoteDailyAstronomyLoader.Error.invalidData
        }
        
        let item = try JSONDecoder().decode(Item.self, from: data)
        
        return item.astronomyItem
    }
}
