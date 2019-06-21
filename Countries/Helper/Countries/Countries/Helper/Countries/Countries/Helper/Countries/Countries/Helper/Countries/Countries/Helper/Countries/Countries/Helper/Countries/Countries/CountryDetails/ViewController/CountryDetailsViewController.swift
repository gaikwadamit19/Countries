//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by amee on 18/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit


class CountryDetailsViewController: UIViewController {
    
    @IBOutlet private weak var countryDetailsView: CountryDetailsView?
    
    private var countryDetailsViewModel: CountryDetailsViewModel = CountryDetailsViewModel()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = ScreenTitles.detail

        if let country: Country = countryDetailsViewModel.country {
            DispatchQueue.main.async { [weak self] in
                self?.countryDetailsView?.updateView(country: country)
            }
        }
    }
    
    /**
     This method sets model data for Country
     
     - Parameter: country: Country Model
     */
    func setCountry(country: Country) {
        countryDetailsViewModel.country = country
    }
    
    /**
     This method saves the country details
     Shows message alert whenver failed or succeed
     */
    @IBAction func saveTheCountryButtonAction() {
        switch countryDetailsViewModel.saveCountryDetails() {
        case true:
            UtilityHelper.showAlertView(message: AlertStrings.countrySavedSuccess)
        case false:
            UtilityHelper.showAlertView(message: AlertStrings.countrySavedFail)
        default:
            //No country details available
            UtilityHelper.showAlertView(message: AlertStrings.noDataAvailable)
        }
    }
}
