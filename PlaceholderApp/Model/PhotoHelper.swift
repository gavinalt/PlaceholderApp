//
//  PhotoHelper.swift
//  PlaceholderApp
//
//  Created by Gavin Li on 4/8/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class PhotoHelper {
    static let cache: LocalCache<String, Data> = {
        let fileUrl = LocalCache<String, Data>.persistencePath(withName: "PlaceholderApp", using: .default)
        if
            let data = try? Data(contentsOf: fileUrl),
            let pCache = try? JSONDecoder().decode(LocalCache<String, Data>.self, from: data) {
            return pCache
        } else {
            return LocalCache<String, Data>.init()
        }
    } ()		
    
    static func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?, Bool) -> ()) {
        if let cachedImg = PhotoHelper.cache[urlString] {
            closure(UIImage(data: cachedImg), false)
        } else {
            
            guard let url = URL(string: urlString) else { return closure(nil, false) }
            
            let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("error: \(String(describing: error))")
                    return closure(nil, false)
                }
                guard response != nil else {
                    print("no response")
                    return closure(nil, false)
                }
                guard data != nil else {
                    print("no data")
                    return closure(nil, false)
                }
                
                DispatchQueue.main.async {
                    if data!.count > 64 {
                        closure(UIImage(data: data!), true)
                        PhotoHelper.cache[urlString] = data
                    } else {
                        closure(nil, false)
                    }
                }
            }; task.resume()
        }
    }
}
