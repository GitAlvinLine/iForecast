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
        let client = HTTPClientSpy()
        let _ = RemoteAstronomyLoader(url: anyURL(), client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteAstronomyLoader(url: anyURL(), client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [anyURL()])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let client = HTTPClientSpy()
        let sut = RemoteAstronomyLoader(url: anyURL(), client: client)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [anyURL(), anyURL()])
    }
    
    // MARK: - Helpers
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }

}
