//
//  Characters.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation

struct CharactersData: Decodable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [result]?
}

struct result: Decodable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: thumbnail?
    var comics: Resources?
    var series: Resources?
    var stories: Resources?
    var events: Resources?

    func imageUrl()-> String? {
        if let path = thumbnail?.path, let ext = thumbnail?.extension {
            return "\(path).\(ext)"
        }
        return nil
    }
}

struct thumbnail: Decodable {
    var path: String?
    var `extension`: String?
}

struct Resources: Decodable {
    var available: Int?
    var collectionURI: String?
    var items: [items]?
}

struct items: Decodable {
    var resourceURI: String?
    var name: String?
}
