//
//  MockServer.swift
//  NEOTrackerTests
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation
@testable import NEOTracker

class MockServer: HttpClient {
    
    static func setup() {
        NetworkingManager.shared.injectClient(client: MockServer())
    }
    
    func send(request: URLRequest, id: UUID, completion: @escaping HttpCompletion) {
        let id = UUID()
        let path = request.url?.path
        let method = request.httpMethod
        
        switch (path, method) {
        case ("/neo/rest/v1/neo/browse", "GET"):
            let data = getJsonData(filename: "NEOResponse")
            completion(data, nil, id)
        default:
            let error = InvalidResponseError(description: "Mock Server does not have route for \(String(describing: method)) \(String(describing: path))")
            completion(nil, error, id)
        }
    }
    
    private func getJsonData(filename: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: filename, ofType: "json") else {
            print("No file for \(filename)")
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Failed to create data for \(path)")
            return nil
        }
    }
}
