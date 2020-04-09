//
//  JsonResponse.swift
//  TheSimpsons
//
//  Created by Gavin Li on 4/3/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

class JsonResponse: Decodable {
    var RelatedTopics: [CharacterProfile]
}
