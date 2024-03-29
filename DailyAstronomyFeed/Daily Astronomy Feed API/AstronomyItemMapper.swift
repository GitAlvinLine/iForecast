//
//  AstronomyItemMapper.swift
//  DailyAstronomyFeed
//
//  Created by Alvin Escobar on 3/19/23.
//

import Foundation

internal enum AstronomyItemMapper {
    
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
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteDailyAstronomyLoader.Result {
        guard response.statusCode == OK_200,
                let item = try? JSONDecoder().decode(Item.self, from: data) else {
            return .failure(RemoteDailyAstronomyLoader.Error.invalidData)
        }
        
        return .success(item.astronomyItem)
    }
}
