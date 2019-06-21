//
//  APIHelper.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit
import Foundation

struct APIHelper {
    
    /**
     This method returns array containing Country structure
     
     - Parameter filePath: file path from which json need to read.
     - Returns: Array of Country objects.
     */
    static func loadCountryData(filePath: String, completionHandler: @escaping ([Country]?, Error?) -> Void) {
        
        guard let jsonUrl = URL(string: filePath) else {
            completionHandler(nil, nil)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let decoder = JSONDecoder()
            do {
                let jsonData: Data = try Data(contentsOf: jsonUrl)
                let countryDataArray: [Country] = try decoder.decode([Country].self, from: jsonData)
                completionHandler(countryDataArray, nil)
            } catch {
                print("Error info: \(error)")
                completionHandler([], error)
            }
        }
    }
}
