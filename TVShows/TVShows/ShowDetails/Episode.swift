//
//  Episode.swift
//  TVShows
//
//  Created by Infinum Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation

struct Episode: Decodable {
    
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeNumber
        case season
        case description
        case imageUrl
        case id = "_id"
    }
}
