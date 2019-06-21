//
//  CoreDataManager.swift
//  Countries
//
//  Created by amee on 19/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let sharedManager: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persitentContainer = NSPersistentContainer(name: CoreDataStrings.country)
        persitentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //TODO: Need to do error handling
            }
        })
        return persitentContainer
    }()
    
    //MARK: Add New Country
    /**
     This method add new country into database
     
     - Parameter flag: Country flag Image in UIImage.
     - Parameter name: Country name in string.
     - Parameter capital: Country capital in string.
     - Parameter callingCodes: Country calling code in string array.
     - Parameter region: Country region in string.
     - Parameter subregion: Country sub region in string.
     - Parameter timezones: Country timezones in string array.
     - Parameter currencies: Country currencies, Currencies object.
     - Parameter languages: Country languages in Languages object.
     - Returns: Country Object created and saved into database.
     */
    
    func insertCountry(flagUrl: String?, flagImage: Data?, name: String?, capital: String?, callingCodes: [String]?, region: String?, subRegion: String?, timeZones: [String]?, currencies: [Currencies]?, languages: [Languages]?) -> Country_? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entityDescriptor = NSEntityDescription.entity(forEntityName: CoreDataStrings.country,
                                                          in: managedContext)!
        let country = NSManagedObject(entity: entityDescriptor,
                                      insertInto: managedContext)
        country.setValue(flagUrl, forKeyPath: CoreDataStrings.properties.flagUrl)
        country.setValue(flagImage, forKeyPath: CoreDataStrings.properties.flagImage)
        country.setValue(name, forKeyPath: CoreDataStrings.properties.name)
        country.setValue(capital, forKeyPath: CoreDataStrings.properties.capital)
        country.setValue(callingCodes, forKeyPath: CoreDataStrings.properties.callingCodes)
        country.setValue(region, forKeyPath: CoreDataStrings.properties.region)
        country.setValue(subRegion, forKeyPath: CoreDataStrings.properties.subRegion)
        country.setValue(timeZones, forKeyPath: CoreDataStrings.properties.timeZones)
        
        var currenciesSet: NSMutableSet = NSMutableSet()
        for currency in currencies ?? [] {
            let currenciesEntityDescriptor = NSEntityDescription.entity(forEntityName: CoreDataStrings.currencies, in: managedContext)!
            let currenciesDescrpt = Currencies_(entity: currenciesEntityDescriptor, insertInto: managedContext)
            currenciesDescrpt.setValue(currency.code, forKeyPath: CoreDataStrings.properties.currencyCode)
            currenciesDescrpt.setValue(currency.name, forKeyPath: CoreDataStrings.properties.currencyName)
            currenciesDescrpt.setValue(currency.symbol, forKeyPath: CoreDataStrings.properties.currencySymbol)
            currenciesSet.add(currenciesDescrpt)
        }
        country.setValue(currenciesSet, forKeyPath: CoreDataStrings.properties.currencies)

        
        var languageSet: NSMutableSet = NSMutableSet()
        for language in languages ?? [] {
            let languageEntityDescriptor = NSEntityDescription.entity(forEntityName: CoreDataStrings.languages, in: managedContext)!
            let languageDescrpt = Languages_(entity: languageEntityDescriptor, insertInto: managedContext)
            languageDescrpt.setValue(language.name, forKeyPath: CoreDataStrings.properties.name)
            languageDescrpt.setValue(language.nativeName, forKeyPath: CoreDataStrings.properties.nativeName)
            languageDescrpt.setValue(language.iso639_1, forKeyPath: CoreDataStrings.properties.iso1)
            languageDescrpt.setValue(language.iso639_2, forKeyPath: CoreDataStrings.properties.iso2)
            languageSet.add(languageDescrpt)
        }
        country.setValue(languageSet, forKeyPath: CoreDataStrings.properties.languages)
                
       do {
            try managedContext.save()
            print("Data saved successfully")
            return country as? Country_
        } catch let error as NSError {
            print("Data failed to save. Error = \(error)")
            return nil
        }
    }
    
 
    //MARK: Fetch Country data
    /**
     This method loads Country Entity from database
     
     - Parameter countryName: country name in string.
     - Returns: Array of Country retrived from database.
     */
    func fetchCountryData(countryName: String?) -> [Country_]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Country_>(entityName: CoreDataStrings.country)
        if let countryName = countryName, !countryName.isEmpty {
            fetchRequest.predicate = NSPredicate(format:"\(CoreDataStrings.properties.name) contains[c] %@", countryName)
        }
        do {
            let propertyList = try managedContext.fetch(fetchRequest)
            return propertyList
        } catch let error as NSError {
            print("Error = \(error)")
            return nil
        }
    }
}
