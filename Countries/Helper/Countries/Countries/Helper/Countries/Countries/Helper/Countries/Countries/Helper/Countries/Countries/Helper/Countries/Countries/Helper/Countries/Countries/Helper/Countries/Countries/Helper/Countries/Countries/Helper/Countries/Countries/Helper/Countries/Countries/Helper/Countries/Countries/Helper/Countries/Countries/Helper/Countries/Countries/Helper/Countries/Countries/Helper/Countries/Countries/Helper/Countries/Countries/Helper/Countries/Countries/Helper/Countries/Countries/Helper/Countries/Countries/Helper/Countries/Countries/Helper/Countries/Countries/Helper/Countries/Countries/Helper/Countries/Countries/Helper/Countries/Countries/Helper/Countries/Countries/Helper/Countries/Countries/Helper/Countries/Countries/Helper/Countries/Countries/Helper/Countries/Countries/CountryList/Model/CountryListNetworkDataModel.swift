//
//  CountryListModel.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit

//MARK: Fetch Data
class CountryListNetworkDataModel {
    /**
     This method provides Airport List Data loaded from Network
     
     - Returns: Airport list of type Array.
     */
    func getCountryList(countryName: String, completionHandler: @escaping ([Country]?, Error?) -> Void) {
        // Server json file
        let countrySearchString = Path.countrySearch.appending("\(countryName)")
        return APIHelper.loadCountryData(filePath: countrySearchString) { (countryList, error) in
            guard error == nil, !(countryList?.isEmpty ?? true) else {
                completionHandler(nil, error)
                return
            }
            completionHandler(countryList?.filter { !($0.name?.isEmpty ?? true) } ?? [], error)
        }
    }
}
