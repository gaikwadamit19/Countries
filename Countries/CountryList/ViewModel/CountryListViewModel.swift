//
//  CountryListViewModel.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import Foundation
import ReactiveSwift

class CountryListViewModel {
        
    fileprivate let countryListNetworkDataModel: CountryListNetworkDataModel = CountryListNetworkDataModel()
    fileprivate var countryListCellViewModelArray: [CountryListCellViewmodel] = []
    fileprivate var countryList: [Country] = []

    var shouldRefreshDataSource: MutableProperty<Bool?> = MutableProperty<Bool?>(nil)
    var shouldRefreshView: MutableProperty<Bool?> = MutableProperty<Bool?>(nil)
    
    fileprivate var reachability: Reachability? {
        didSet {
            startNotifier()
        }
    }
    var isUserOnline: Bool? = nil

    init() {
        setupReachability(hostName: Path.domainAddress)
    }

    //MARK: Table Data Source Getter
    /**
     Returns data source for cells on the basis of search string
     Collect data when first character hits search bar and holds data for next search
     
     - Parameter countryName: text for which search need to be done.
     - Returns: Array of CountryListCellViewmodel
     */
    func getCountryListDataSource(countryName: String) -> [CountryListCellViewmodel] {
        //When offline, load local data
        guard isUserOnline == true else {
            loadSavedCountryDetailsFromStorage(countryName: countryName)
            return countryListCellViewModelArray
        }

        //When online and country name is empty dont show anything
        guard !countryName.isEmpty else {
            countryListCellViewModelArray.removeAll()
            return countryListCellViewModelArray
        }
        
        //Need to load data for first character from API, and collect it in array
        if countryName.count == 1, countryListCellViewModelArray.isEmpty {
            //Clear datasource
            shouldRefreshDataSource.value = false
            loadSearchResult(countryName: countryName) { [weak self] (countryCellViewModelList) in
                //Once result get loaded
                if let countryCellViewModelList: [CountryListCellViewmodel] = countryCellViewModelList, !countryCellViewModelList.isEmpty {
                    self?.countryListCellViewModelArray.append(contentsOf: countryCellViewModelList)
                }
                self?.shouldRefreshDataSource.value = true
            }
        } else {
            //Return search result from already loaded data, no need to hit API
            return countryListCellViewModelArray.lazy.filter { return isPropertyContainsMatchingText(parentString: ("\($0.getCountryName() ?? "")"), subString: countryName) }
        }
        return countryListCellViewModelArray
    }
    
    //MARK: Country Details Getter
    /**
     Returns Country Object for specified country name
     
     - Returns: Country.
     */
    func getCountry(name: String) -> Country? {
        return countryList.lazy.first { $0.name == name }
    }
}

//MARK: Load search data
extension CountryListViewModel {
    /**
     Returns data source for cells using API for search
     Collect data when first character hits search bar and holds data for next search
     
     - Returns: Array of CountryListCellViewmodel with closure
     */
    private func loadSearchResult(countryName: String, completionHandler: @escaping ([CountryListCellViewmodel]?) -> Void) {
        countryListNetworkDataModel.getCountryList(countryName: countryName) { [weak self] (countryList, error) in
            guard error == nil, let countryList = countryList  else {
                UtilityHelper.showAlertView(message: AlertStrings.unableToLoadJsonError)
                completionHandler([])
                return
            }
            guard !countryList.isEmpty else {
                UtilityHelper.showAlertView(message: AlertStrings.unableToLoadJsonError)
                completionHandler([])
                return
            }
            self?.countryList = countryList
            var countryCellViewModelList: [CountryListCellViewmodel] = []
            for country in countryList {
                let countryCellViewModel: CountryListCellViewmodel = CountryListCellViewmodel(countryName: country.name, countryFlagUrl: country.flag, countryFlagImage: nil)
                countryCellViewModelList.append(countryCellViewModel)
            }
            completionHandler(countryCellViewModelList)
        }
    }
    
    /**
     Returns data source for cells using API for search
     Collect data when first character hits search bar and holds data for next search
     
     - Returns: Array of CountryListCellViewmodel with closure
     */
    private func loadSavedCountryDetailsFromStorage(countryName: String? = nil)  {
        countryListCellViewModelArray.removeAll()
        countryList.removeAll()
        guard let storedCountryList: [Country_] = CoreDataManager.sharedManager.fetchCountryData(countryName: countryName) else {
            return
        }
        
        for countryEntity in storedCountryList {
            let countryCellViewModel: CountryListCellViewmodel = CountryListCellViewmodel(countryName: countryEntity.name, countryFlagUrl: countryEntity.flagUrl)
            
            var lanuagesArray: [Languages] = [Languages]()
            lanuagesArray = countryEntity.languages?.reduce([Languages](), { (result, value) in
                let languages: Languages? = value as? Languages
                lanuagesArray.append(Languages(iso639_1: languages?.iso639_1, iso639_2: languages?.iso639_2, name: languages?.name, nativeName: languages?.nativeName))
                return lanuagesArray
            }) ?? []
            
            var currencyArray: [Currencies] = [Currencies]()
            currencyArray = countryEntity.currencies?.reduce([Currencies](), { (result, value) in
                let currencies: Currencies? = value as? Currencies
                currencyArray.append(Currencies(code: currencies?.code, name: currencies?.name, symbol: currencies?.symbol))
                return currencyArray
            }) ?? []
            
            let updatedCountryObject: Country = Country(flag: countryCellViewModel.getCountryFlagUrl(), name: countryEntity.name, capital: countryEntity.capital, callingCodes: countryEntity.callingCodes as? [String], region: countryEntity.region, subregion: countryEntity.subRegion, timezones: countryEntity.timeZones as? [String], currencies: currencyArray, languages: lanuagesArray )
            countryList.append(updatedCountryObject)
            
            if let imageData: Data = countryEntity.flagImage, let image: UIImage = UIImage.init(data: imageData) {
                countryCellViewModel.setCountryImage(image: image)
            }
            countryListCellViewModelArray.append(countryCellViewModel)
        }
    }
}

//MARK: Search Helpers
extension CountryListViewModel {
    /**
     This method check if string contains substring or not
     
     - Parameter parentString: Main string in which we need to search.
     - Parameter subString: String which we need to search.
     - Returns: Boolean value as tru or false.
     */
    private func isPropertyContainsMatchingText(parentString: String, subString: String) -> Bool {
        let range = parentString.range(of: subString, options: .caseInsensitive)
        return range != nil
    }
}

//MARK: Internet Rechability
extension CountryListViewModel {

    /**
     This method setup rechability with host url
     It holds closure handler which can help to monitor rechability current state
     
     - Parameter hostName: string url to check rechability.
     */
    private func setupReachability(hostName: String?) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
        } else {
            reachability = try? Reachability()
        }
        self.reachability = reachability
        print("--- set up with host name: \(hostName ?? "N/A")")
        
            reachability?.whenReachable = { [weak self] reachability in
                print("Internet Reachable")
                self?.isUserOnline = true
                self?.shouldRefreshView.value = true
                self?.shouldRefreshDataSource.value = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UtilityHelper.showAlertView(message: AlertStrings.internetConnectionComeBack)
                }
            }
            reachability?.whenUnreachable = { [weak self] reachability in
                print("Internet Not Reachable")
                self?.isUserOnline = false
                self?.shouldRefreshView.value = true
                self?.shouldRefreshDataSource.value = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UtilityHelper.showAlertView(message: AlertStrings.internetConnectionGoesOff)
                }
            }
    }
    
    
    /**
     This method start rechability notifier.
     It starts the rechability process with startNotifier function
     */
    private func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable To Start Notifier")
            return
        }
    }
    
    /**
     This method stop rechability notifier.
     It stop the rechability process until to start it again
     */
    func stopNotifier() {
        print("Notifier Stoped")
        reachability?.stopNotifier()
        reachability = nil
    }
}
