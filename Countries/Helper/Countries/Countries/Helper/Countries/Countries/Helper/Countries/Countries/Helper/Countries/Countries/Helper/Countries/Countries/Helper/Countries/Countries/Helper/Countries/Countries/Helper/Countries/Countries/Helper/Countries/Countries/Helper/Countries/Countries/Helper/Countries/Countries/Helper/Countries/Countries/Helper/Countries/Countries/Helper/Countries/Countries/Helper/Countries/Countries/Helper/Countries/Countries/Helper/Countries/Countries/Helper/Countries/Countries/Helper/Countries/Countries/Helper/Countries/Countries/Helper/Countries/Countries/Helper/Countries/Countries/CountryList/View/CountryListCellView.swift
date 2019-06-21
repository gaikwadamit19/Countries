//
//  CountryListCellView.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit

class CountryListCellView: UITableViewCell {
    
    @IBOutlet weak var countryFlagImageView: UIImageView?
    @IBOutlet weak var countryNameLabel: UILabel?
    
    //MARK: Configure View
    /**
     This method configure the view for setting images and texts
     
     - Parameter cellViewModel: view model which is responsible for managing that view.
     */
    func configureView(cellViewModel: CountryListCellViewmodel) {
        countryNameLabel?.text = cellViewModel.getCountryName()
        cellViewModel.getCountryFlagImage { [weak self] (flagImage) in
            if let countryFlagImage: UIImage = flagImage {
                self?.countryFlagImageView?.image = countryFlagImage
            }
        }
    }
}
