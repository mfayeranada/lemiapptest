//
//  City.swift
//  LemiAppTest
//
//  Created by Meredith Faye Ranada on 11/05/2019.
//  Copyright © 2019 Meredith Faye Ranada. All rights reserved.
//

import Foundation

struct City {
    
    var name: String?
    var subtitle: String?
    var countryCode: String?
    var population: Int?
    var type: String?
    var id: String?
    var banner: String?
    var color: String?
    var longitude: Double?
    var latitude: Double?
    var zoom: Int?
    
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.subtitle = dictionary["subtitle"] as? String
        self.countryCode = dictionary["country_code"] as? String
        self.population = dictionary["population"] as? Int
        self.type = dictionary["type"] as? String
        self.id = dictionary["id"] as? String
        self.banner = dictionary["banner"] as? String
        self.color = dictionary["color"] as? String
        self.longitude = dictionary["longitude"] as? Double
        self.latitude = dictionary["latitude"] as? Double
        self.zoom = dictionary["zoom"] as? Int
    }
    
}
