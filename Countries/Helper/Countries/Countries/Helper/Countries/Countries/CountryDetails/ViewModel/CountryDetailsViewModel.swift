//
//  CountryDetailsViewModel.swift
//  Countries
//
//  Created by amee on 18/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit
import CoreData

class CountryDetailsViewModel {
    var country: Country?
    
    /**
     This method saves the country details using core data
     
     - Returns: BOOl value
     */
    func saveCountryDetails() -> Bool? {
        guard let country: Country = country else {
            //Cant save this object
            return nil
        }
        
        //let imageData = UIImage(named: "default")?.pngData()
        if CoreDataManager.sharedManager.insertCountry(flagUrl: country.flag, flagImage: nil, name: country.name, capital: country.capital, callingCodes: country.callingCodes, region: country.region, subRegion: country.subregion, timeZones: country.timezones, currencies: country.currencies, languages: country.languages) != nil {
            return true
        } else {
            return false
        }
    }
}
