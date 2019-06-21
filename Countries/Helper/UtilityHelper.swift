//
//  UtilityHelper.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit

class UtilityHelper {
    /**
     This method helps to show Alert Controller
     
     - Parameter message: Text need to show to user.
     - Parameter viewController: On which AlertView will get shown.
     */
    static func showAlertView(message: String) {
        let alertController = UIAlertController(title: AlertStrings.alert, message: message, preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: AlertStrings.alertButton, style: .default, handler: nil)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.visibleViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
