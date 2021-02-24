//
//  HikingTour.swift
//  Cityu_FYP
//
//  Created by Kam on 17/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import Foundation

struct HikingTour: Codable {
    var id: Int
    var hikingrouteid: Int
    var hostid: Int
    var restaurantid: Int?
    var restaurantincluded: Bool
    var tourname: String
    var tourdescription: String
    var price: Int
    var maximumparticipant: Int
    var minimumparticipant: Int
    var dateandtime: String
    var createdat: String
    var deletedat: String?
    var hikingrouteimage: String
    var hikingroutename: String
    var hostname: String
}
