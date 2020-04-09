//
//  Network.swift
//  TheSimpsons
//
//  Created by Gavin Li on 4/3/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

//
// MARK: - Network
//
class Network {
    //
    // MARK: - Class Methods
    //
    static func loadJSONFile<T: Decodable>(named filename: String,
                                           type: T.Type,
                                           queue: DispatchQueue? = DispatchQueue.main,
                                           simulateLoadDelay: Bool? = true,
                                           delaySeconds: TimeInterval = 0.2,
                                           completionHandler: @escaping (T?, NetworkError?) -> Void) {
//        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
//            if let dispatchQueue = queue {
//                dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delaySeconds) {
//                    completionHandler(nil, .invalidPath)
//                }
//            } else {
//                completionHandler(nil, .invalidPath)
//            }
//
//            return
//        }
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completionHandler(nil, .invalidPath)
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
            
            if statusCode != 200 {
                if let dispatchQueue = queue {
                    dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delaySeconds) {
                        completionHandler(nil, .requestError)
                    }
                } else {
                    completionHandler(nil, .requestError)
                }
                
                return
            }
            
            do {
                if let jsonData = data {
                    let decoder = JSONDecoder()
//                    decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
//                        let value = try decoder.singleValueContainer().decode(String.self)
//
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd"
//
//                        if let date = formatter.date(from: value) {
//                            return date
//                        }
//
//                        throw NetworkError.dateParseError
//                    }
                    
                    let typedObject: T? = try decoder.decode(T.self, from: jsonData)
                    
                    if let dispatchQueue = queue {
                        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delaySeconds) {
                            completionHandler(typedObject, nil)
                        }
                    } else {
                        completionHandler(typedObject, nil)
                    }
                }
            } catch {
                print(error)
                
                if let dispatchQueue = queue {
                    dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delaySeconds) {
                        completionHandler(nil, .parseError)
                    }
                } else {
                    completionHandler(nil, .parseError)
                }
            }
        }
        
        dataTask.resume()
    }
}

//
// MARK: - Network Error
//
enum NetworkError: Error {
    //
    // MARK: - Cases
    //
    case dateParseError
    case invalidPath
    case parseError
    case requestError
}
