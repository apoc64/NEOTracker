//
//  NetwokingManager.swift
//  NEOTracker
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation

typealias HttpCompletion = (Data?, Error?, UUID) -> ()
typealias ServiceResponseCompletion = (Codable?, Error?, UUID) -> ()
protocol HttpClient {
    func send(request: URLRequest, id: UUID, completion: @escaping HttpCompletion )
}

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private var httpClient: HttpClient?
    
    private init() {
        self.httpClient = HTTPExecutor()
    }
    
    #if DEBUG
    // Inject a mock for testing
    func injectClient(client: HttpClient) {
        httpClient = client
    }
    #endif
    
    var primaryBaseURL: String {
        // switch based on environments
        return "https://api.nasa.gov"
    }
    
    var baseHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func send<T: Codable>(request: NetworkingRequest, responseType: T.Type, completion: @escaping ServiceResponseCompletion) {
        let baseURL = request.baseUrl ?? primaryBaseURL
        let url = "\(baseURL)\(request.path)"
        let headers = baseHeaders.merging(request.headers ?? [:]) { (_, new) in new }
        do {
            let requestID = UUID()
            var request = try URLRequest(url: url, method: request.method, headers: headers)
            request.httpBody = request.httpBody
            httpClient?.send(request: request, id: requestID, completion: { (responseData, error, id) in
                guard error == nil else { completion(nil, error, id); return }
                guard let data = responseData else {
                    completion(nil, InvalidResponseError(description: "Service received no data"), id)
                    return
                }
                self.parseResponse(responseData: data, responseType: responseType, id: id, completion: completion)
            })
        } catch {
            log("Failed to create URLRequest for: \(request.method.rawValue), \(url)")
        }
    }
    
    private func parseResponse<T: Codable>(responseData: Data, responseType: T.Type, id: UUID, completion: ServiceResponseCompletion) {
        do {
            let responseObject = try JSONDecoder().decode(responseType, from: responseData)
            completion(responseObject, nil, id)
        } catch {
            completion(nil, InvalidResponseError(description: "Cound not parse response"), id)
        }
    }
}

import Alamofire
fileprivate class HTTPExecutor: HttpClient {
    
    func send(request: URLRequest, id: UUID, completion: @escaping HttpCompletion) {
        log("Preparing HTTP Request: \(request.httpMethod ?? "NO METHOD"), \(request.url?.absoluteString ?? "NO URL"), ID: \(id.uuidString)")
        Alamofire.request(request).responseJSON(completionHandler: { (response) in
            guard response.error == nil else {
                self.completeWithError(error: response.error!, completion: completion, id: id)
                return
            }
            guard let responseData = response.data else {
                self.completeWithError(error: InvalidResponseError(), completion: completion, id: id)
                return
            }
            log("Request completed successfully. ID: \(id)")
            completion(responseData, nil, id)
        })
    }
    
    func completeWithError(error: Error, completion: HttpCompletion, id: UUID) {
        log("Request completed with error: \(error.localizedDescription), ID: \(id)")
        completion(nil, error, id)
    }
    
}

struct InvalidResponseError: Error {
    var localizedDescription: String { return errorDescription }
    
    private let errorDescription: String
    
    init(description: String = "Invalid/No Response") {
        self.errorDescription = description
    }
}

struct NetworkingRequest {
    let method: HTTPMethod
    let path: String
    let body: Data?
    let headers: [String: String]?
    let baseUrl: String?
    
    init(method: HTTPMethod, path: String, body: Data? = nil, headers: [String: String]? = nil, baseUrl: String? = nil) {
        self.method = method
        self.path = path
        self.body = body
        self.headers = headers
        self.baseUrl = baseUrl
    }
}
