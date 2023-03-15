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
        let (_, client) = makeSUT(url: anyURL())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT(url: anyURL())
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [anyURL()])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let (sut, client) = makeSUT(url: anyURL())
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [anyURL(), anyURL()])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteAstronomyLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAstronomyLoader(url: url, client: client)
        return (sut, client)
    }
    
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
