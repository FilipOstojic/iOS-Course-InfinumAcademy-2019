//
//  Comments.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//
import Foundation

struct Comment: Decodable {
    var text: String
    var episodeId: String
    var userEmail: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}
