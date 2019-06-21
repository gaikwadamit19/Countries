//
//  Country.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import Foundation

//MARK: Currency structure
struct Currencies: Codable, Hashable {
    var code: String?
    var name: String?
    var symbol: String?
}

//MARK: Language structure
struct Languages: Codable, Hashable {
    var iso639_1: String?
    var iso639_2: String?
    var name: String?
    var nativeName: String?
}

//MARK: Structure as per Country fields in API
struct Country: Codable, Hashable {
    var flag: String?
    var name: String?
    var capital: String?
    var callingCodes: [String]?
    var region: String?
    var subregion: String?
    var timezones: [String]?
    var currencies: [Currencies]?
    var languages: [Languages]?
}
