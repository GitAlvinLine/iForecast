//
//  LoadDailyAstronomyItemFromRemoteUseCaseTests.swift
//  DailyAstronomyFeedTests
//
//  Created by Alvin Escobar on 3/14/23.
//

import XCTest
import DailyAstronomyFeed

final class LoadDailyAstronomyItemFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT(url: anyURL())
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let (sut, client) = makeSUT(url: anyURL())
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [anyURL()])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let (sut, client) = makeSUT(url: anyURL())
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [anyURL(), anyURL()])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: 400, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversAstronomyItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = makeSUT()
        
        let (item, json) = makeItem(date: "2023-03-18",
                                 explanation: "Explantion",
                                 title: "Title",
                                 imageURL: URL(string: "https://any-url.com")!)
        
        expect(sut, toCompleteWith: .success(item), when: {
            client.complete(withStatusCode: 200, data: makeItemJSON(json))
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteDailyAstronomyLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteDailyAstronomyLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeItem(date: String, explanation: String, title: String, imageURL: URL) -> (model: AstronomyItem, json: [String:Any]) {
        let item = AstronomyItem(date: date, explanation: explanation, title: title, imageURL: imageURL)
        
        let json = [
            "date": date,
            "explanation": explanation,
            "title": title,
            "url": imageURL.absoluteString
        ]
        
        return (item, json)
    }
    
    private func makeItemJSON(_ item: [String:Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: item)
    }
    
    private func expect(_ sut: RemoteDailyAstronomyLoader, toCompleteWith result: RemoteDailyAstronomyLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteDailyAstronomyLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }

}
