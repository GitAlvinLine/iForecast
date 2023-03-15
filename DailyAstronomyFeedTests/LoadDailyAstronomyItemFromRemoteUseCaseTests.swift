//
//  LoadDailyAstronomyItemFromRemoteUseCaseTests.swift
//  DailyAstronomyFeedTests
//
//  Created by Alvin Escobar on 3/14/23.
//

import XCTest
import DailyAstronomyFeed

final class RemoteAstronomyLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

final class LoadDailyAstronomyItemFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let _ = RemoteAstronomyLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }

}
