//
//  hikingRoute.swift
//  Cityu_FYP
//
//  Created by Kam on 12/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import Foundation

struct HikingRoute: Codable {
    var id: Int
    var name: String
    var description: String
    var hikingrouteimage: String?
    var location: String
    var difficulty: String
    var distance: Double
    var elevationgain: Int
    var stars: Int
    var routetype: String
    var dogfriendly: Bool
    var kidfriendly: Bool
    var camping: Bool
    var river: Bool
    var wildflower: Bool
    var wildlife: Bool
    var estimatedduration: Int
    var startlatitude: Double
    var endlatitude: Double
    var startlongitude: Double
    var endlongitude: Double
    var createdat: String
    var deletedat: String?
    var userrating: Int?
    var userliked: Bool?
    var jaccardsimilarityscore: Double?
    var recommendedbycontentbased: Bool?
    var recommendedbycollaborativefiltering: Bool?
    var recommendedforcoldstart: Bool?
}
