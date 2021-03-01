//
//  CodableDefinition.swift
//  Cityu_FYP
//
//  Created by Kam on 12/2/2021.
//  Copyright © 2021 Kam. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var message: String
    var token: String?
    var user: User
}

struct HikingRouteResponse: Codable {
    var message: String
    var hikingRoute: HikingRoute
}

struct HikingRoutesResponse: Codable {
    var message: String
    var hikingRoutes: [HikingRoute]
}

struct HikingTourResponse: Codable {
    var message: String
    var hikingTour: HikingTour
}

struct HikingToursResponse: Codable {
    var message: String
    var hikingTours: [HikingTour]
}

struct JoinTourResponse: Codable {
    var message: String
}

