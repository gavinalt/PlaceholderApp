//
//  Photo.swift
//  PlaceholderApp
//
//  Created by Gavin Li on 4/7/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class Photo: Codable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case albumId = "albumId"
        case id
        case title
        case url
        case thumbnailUrl
    }
}
