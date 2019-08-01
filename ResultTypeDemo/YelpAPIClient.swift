//
//  YelpAPIClient.swift
//  ResultTypeDemo
//
//  Created by Genesis Mosquera on 8/1/19.
//  Copyright © 2019 Genesis Mosquera. All rights reserved.
//
import Foundation

enum NetworkError: Error {
    case badURL
    case badStatusCode
    case apiError(Error)
    case jsonDecodingError(Error)
}

class YelpAPIClient {
    // Result type in Swift 5 in a generic enum used on asychrousnous calls,
    // the Result is an enum that validates a .success or .failure against the call
    public func searchBusinesses(completion: @escaping (Result<[Business], NetworkError>) -> Void) {
        let endPointURL = "https://api.yelp.com/v3/businesses/search?term=coffee&location=10023"
        guard let url = URL(string: endPointURL) else {
            completion(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        let accessToken = SecretKeys.YelpAPIKey
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.apiError(error)))
            } else if let data = data {
                // TODO : using JSON Decoder parse data to [Business]
                //completion(.success(200))
              //  completion(.success(Business))
                do {
                let model = try JSONDecoder().decode(BusinessesSearch.self, from: data)
                    print(model)
                } catch {
                   completion(.failure(.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}
