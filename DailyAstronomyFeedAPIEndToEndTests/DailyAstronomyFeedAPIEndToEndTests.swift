//
//  DailyAstronomyFeedAPIEndToEndTests.swift
//  DailyAstronomyFeedAPIEndToEndTests
//
//  Created by Alvin Escobar on 3/20/23.
//

import XCTest
import DailyAstronomyFeed

final class DailyAstronomyFeedAPIEndToEndTests: XCTestCase {
    
    func test_endToEndServerGETAstronomyItemResult_hasData() {
        let apiKey = "Vw08T8hJGYTwWTzHnqOygQTxXAnVhU29HmE2Bcij"
        let serverURL = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)")!
        let client = URLSessionHTTPClient()
        let loader = RemoteDailyAstronomyLoader(url: serverURL, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: DailyAstronomyResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15.0)
        
        switch receivedResult {
        case let .success(astronomyItem)?:
            XCTAssertFalse(astronomyItem.date.isEmpty, "Expected to have a value for the date, but has no value.")
            XCTAssertFalse(astronomyItem.explanation.isEmpty, "Expected to have a value for explanation, but has no value.")
            XCTAssertFalse(astronomyItem.imageURL.absoluteString.isEmpty , "Expected to have a value for the URL, but has no URL absolute path.")
            XCTAssertFalse(astronomyItem.title.isEmpty, "Expected to have a value for the title, but has no value.")
            
        case let .failure(error)?:
            XCTFail("Expected successful astronomy item result, got \(error) instead")
            
        default:
            XCTFail("Expected successful astronomy item result, got no result instead")
        }
    }
}
