//
//  CountryDetailsView.swift
//  Countries
//
//  Created by amee on 18/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit


class CountryDetailsView: UIView {
        
    @IBOutlet private weak var countryFlagImage: UIImageView?
    @IBOutlet private weak var countryName: UILabel?
    @IBOutlet private weak var capital: UILabel?
    @IBOutlet private weak var callingCode: UILabel?
    @IBOutlet private weak var region: UILabel?
    @IBOutlet private weak var subRegion: UILabel?
    @IBOutlet private weak var timeZone: UILabel?
    @IBOutlet private weak var currencies: UILabel?
    @IBOutlet private weak var languages: UILabel?
    
    //MARK: Configure
    /**
     This method configure the view for setting texts to labels
     
     - Parameter cellViewModel: view model which is responsible for providing data to view.
     */
    func updateView(country: Country?) {
        countryFlagImage?.image = UIImage(named: DefaultValues.image)
        if let flagUrl = country?.flag {
            APIHelper.loadImage(filePath: flagUrl) { [weak self] (flagImage) in
                DispatchQueue.main.async { [weak self] in
                    self?.countryFlagImage?.image = flagImage
                }
            }
        }
        countryName?.text = country?.name ?? DefaultValues.label
        capital?.text = country?.capital ?? DefaultValues.label
        callingCode?.text = country?.callingCodes?.joined(separator: ", ") ?? DefaultValues.label
        region?.text = country?.region ?? DefaultValues.label
        subRegion?.text = country?.subregion ?? DefaultValues.label
        timeZone?.text = country?.timezones?.joined(separator: ", ") ?? DefaultValues.label
        currencies?.text = country?.currencies?.reduce(String()) { (dict, value) in
            let currencies: Currencies = value
            return "".appendingFormat("\(CurrencyStrings.name): \(currencies.name ?? "")\n\(CurrencyStrings.code): \(currencies.code ?? "")\n\(CurrencyStrings.symbol): \(currencies.symbol ?? "")")
        }
        languages?.text = country?.languages?.reduce(String(), { (dict, value) in
            let language: Languages = value
            return "".appendingFormat("\(LanguageStrings.name): \(language.name ?? "")\n\(LanguageStrings.nativeName):\(language.nativeName ?? "")\n\(LanguageStrings.iso1): \(language.iso639_1 ?? "")\n\(LanguageStrings.iso2): \(language.iso639_2 ?? "")")
        })
    }
    
}
