//
//  Constant.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

//MARK: Screen Title
enum ScreenTitles {
    static let country: String = "Search Country"
    static let detail: String = "Country Details"
}

//MARK: Cell Identifires
enum Identifires {
    static let countryTableViewCell = "CountryTableViewCellIdentifire"
    static let detailSegue: String = "DetailSegueIdentifire"
}

//MARK: JSON Data
enum Path {
    static let countrySearch: String = "https://restcountries.eu/rest/v2/name/"
    static let domainAddress: String = "restcountries.eu"
}

//MARK: Alert Utility
enum AlertStrings {
    static let alert: String = "Alert"
    static let alertButton: String = "OK"
    static let unableToLoadJsonError: String = "Sorry!! Unable to load Country Data. Please try again later"
    static let noDataAvailable: String = "Sorry!! No data available. Please try again later"
    static let countrySavedSuccess: String = "Congratulations!! Country saved successfully."
    static let countrySavedFail: String = "Sorry!! Unable to save country this time. Please try again later."
    static let internetConnectionComeBack: String = "Internet Is Available!! You can search countries online."
    static let internetConnectionGoesOff: String = "Internet Goes Off!! You can search only saved countries now."
}

//MARK: Default values
enum DefaultValues {
    static let image: String = "default"
    static let label: String = "N/A"
}

//MARK: Core Data
enum CoreDataStrings {
    static let country: String = "Country_"
    static let currencies: String = "Currencies_"
    static let languages: String = "Languages_"
    
    enum properties {
        static let flagUrl: String = "flagUrl"
        static let flagImage: String = "flagImage"
        static let name: String = "name"
        static let capital: String = "capital"
        static let callingCodes: String = "callingCodes"
        static let region: String = "region"
        static let subRegion: String = "subRegion"
        static let timeZones: String = "timeZones"
        static let currencies: String = "currencies"
        static let languages: String = "languages"
        
        static let currencyCode: String = "code"
        static let currencyName: String = "name"
        static let currencySymbol: String = "symbol"
        
        static let languageName: String = "name"
        static let nativeName: String = "nativeName"
        static let iso1: String = "iso639_1"
        static let iso2: String = "iso639_2"
    }
}

//MARK: Currency Structure Strings
enum CurrencyStrings {
    static let code: String = "Code"
    static let name: String = "Name"
    static let symbol: String = "Symbol"
}


//MARK: Language Structure Strings
enum LanguageStrings {
    static let name: String = "Name"
    static let nativeName: String = "NativeName"
    static let iso1: String = "ISO639_1"
    static let iso2: String = "ISO639_2"
}

//MARK: Rechability
enum RechabilityConstants {
    static let timerValue: Int = 5
}
