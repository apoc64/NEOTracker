//
//  NEOService.swift
//  NEOTracker
//
//  Created by Steven Schwedt on 11/17/19.
//  Copyright © 2019 Steven Schwedt. All rights reserved.
//

import Foundation

struct NEO: Codable, Identifiable {
    let id: Int = Int.random(in: 1...99999)
    
    let name: String
    let designation: String
    let isDangerous: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, designation
        case isDangerous = "is_potentially_hazardous_asteroid"
    }
    
    static func requestNeos(completion: @escaping (NeoResponse?, Error?) -> ()) {
        let path = "/neo/rest/v1/neo/browse?page=1&size=20&api_key=DEMO_KEY"
        let request = NetworkingRequest(method: .get, path: path)
        NetworkingManager.shared.send(request: request, responseType: NeoResponse.self, completion: { (response, error, id) in
            let response = response as? NeoResponse
            completion(response, error)
        })
    }
}

struct NeoResponse: Codable {
    let neos: [NEO]
    
    enum CodingKeys: String, CodingKey {
        case neos = "near_earth_objects"
    }
}
