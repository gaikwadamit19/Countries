//
//  CountryListCellViewmodel.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit

class CountryListCellViewmodel {
    private var countryName: String?
    private var countryFlagUrl: String?
    private var countryFlagImage: UIImage?
    
    init(countryName: String?, countryFlagUrl: String?, countryFlagImage: UIImage? = nil) {
        self.countryName = countryName
        self.countryFlagUrl = countryFlagUrl
        self.countryFlagImage = countryFlagImage
    }

    //MARK: Setter property
    /**
     This method set UIImage for cell view model     
     */
    func setCountryImage(image: UIImage?) {
        countryFlagImage = image
    }

    
    //MARK: Getters property
    /**
     This method provides City Name for cell view model
     
     - Returns: City Name string value
     */
    func getCountryName() -> String? {
        return countryName
    }
    
    /**
     This method provides City Name for cell view model
     
     - Returns: City Name string value
     */
    func getCountryFlagUrl() -> String? {
        return countryFlagUrl
    }
    
    /**
     This method provides Country flag image for cell view model
     
     - Returns: UIImage
     */
    func getCountryFlagImage(completionHandler: @escaping (UIImage?) -> Void) {
//        if let countryFlagImage = countryFlagImage {
//            return completionHandler(countryFlagImage)
//        }
        
        if let flagUrl = getCountryFlagUrl() {
            ImageLoader.shared.imageForUrl(filePath: flagUrl) { (image) in
                completionHandler(image)
            }
        }
        
//        if let flagUrl = getCountryFlagUrl() {
//            APIHelper.loadImage(filePath: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png") { (image) in
//                if let image = image {
//                    completionHandler(image)
//                }
//            }
//        }
    }
}

