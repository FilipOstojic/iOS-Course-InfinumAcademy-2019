//
//  ShowDetails.swift
//  TVShows
//
//  Created by Infinum Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation

struct ShowDetails: Decodable {
    
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case description
        case imageUrl
        case likesCount
        case id = "_id"
    }
}
