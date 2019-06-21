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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(notification:)),
            name: .reachabilityChanged,
            object: nil
        )
    }
    
    
    
    /**
     This method sets model data for Country
     
     - Parameter: country: Country Model
     */
    func setCountry(country: Country, flagImage: UIImage? = nil, isUserOnline: Bool) {
        countryDetailsViewModel.country = country
        countryDetailsViewModel.flagImage = flagImage
        countryDetailsViewModel.isUserOnline = isUserOnline
        //Uodate view
        if let country: Country = countryDetailsViewModel.country {
            countryDetailsView?.updateView(country: country, isUserOnline: isUserOnline)
        }
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

//Notification Observer
extension CountryDetailsViewController {
    /**
     This method helps to listen notification
     Hide the save button as per isUserOnline
     */
    @objc func reachabilityChanged(notification: Notification) {
        if let reachability = notification.object as? Reachability {
            let isUserOnline = reachability.connection != .none
            countryDetailsView?.updateSubmitButtonAppearance(isUserOnline: isUserOnline)
        }
    }
}
