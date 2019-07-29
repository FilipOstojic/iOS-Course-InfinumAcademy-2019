//
//  Media.swift
//  TVShows
//
//  Created by Infinum Infinum on 29/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation

struct Media: Decodable {
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
