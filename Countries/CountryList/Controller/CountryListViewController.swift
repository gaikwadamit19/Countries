//
//  ViewController.swift
//  Countries
//
//  Created by amee on 17/06/19.
//  Copyright © 2019 amee. All rights reserved.
//

import UIKit
import ReactiveSwift

class CountryListViewController: UIViewController {
    
    @IBOutlet weak var countryListTableView: UITableView?
    @IBOutlet weak var countryListSearchBar: UISearchBar?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    private let countryListViewModel: CountryListViewModel = CountryListViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = ScreenTitles.country
        countryListSearchBar?.becomeFirstResponder()
        
        //Producer for communication between view controller and view model
        countryListViewModel.shouldRefreshDataSource.producer
            .filter { $0 != nil }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] (shouldUpdate) in
                if let weakSelf = self {
                    if shouldUpdate == true {
                        weakSelf.activityIndicator?.stopAnimating()
                        weakSelf.countryListTableView?.reloadData()                        
                    } else {
                        weakSelf.activityIndicator?.startAnimating()
                    }
                }
        }
        
        countryListViewModel.shouldRefreshView.producer
            .filter { $0 != nil }
            .observe(on: UIScheduler())
            .startWithValues { [weak self] (shouldRefresh) in
                if let weakSelf = self {
                    if shouldRefresh == true {
                        weakSelf.countryListSearchBar?.text = ""
                    }
                }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Identifires.detailSegue else {
            return
        }
        let cellViewModelList: [CountryListCellViewmodel] = countryListViewModel.getCountryListDataSource(countryName: countryListSearchBar?.text ?? "")
        if let viewController: CountryDetailsViewController = segue.destination as? CountryDetailsViewController, let indexPath = sender as? IndexPath, !cellViewModelList.isEmpty {
            let countryListCellViewModel: CountryListCellViewmodel = cellViewModelList[indexPath.row]
            if let countryName: String = countryListCellViewModel.getCountryName(), let country: Country = countryListViewModel.getCountry(name: countryName) {
                if let flagUrl: String = countryListCellViewModel.getCountryFlagUrl() {
                    ImageLoader.shared.imageForUrl(filePath: flagUrl) { [weak self] (image) in
                        viewController.setCountry(country: country, flagImage: image, isUserOnline: self?.countryListViewModel.isUserOnline ?? true)
                    }
                } else {
                    viewController.setCountry(country: country, isUserOnline: countryListViewModel.isUserOnline ?? true)
                }
            }
        }
    }
    
    deinit {
        countryListViewModel.stopNotifier()
    }
}


//MARK: TableViewDatasource
extension CountryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryListViewModel.getCountryListDataSource(countryName: countryListSearchBar?.text ?? "").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Identifires.countryTableViewCell, for: indexPath)
        (tableViewCell as? CountryListCellView)?.configureView(cellViewModel: countryListViewModel.getCountryListDataSource(countryName: countryListSearchBar?.text ?? "")[indexPath.row])
        return tableViewCell
    }
}

//MARK: TableViewDelegate
extension CountryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifires.detailSegue, sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: Search
extension CountryListViewController: UISearchBarDelegate {
    
    /**
     This delegate Method handles cancel button action and clear search UI
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        countryListSearchBar?.text = ""
        searchBar.resignFirstResponder()
        countryListTableView?.reloadData()
    }
    
    /**
     This delegate Method hit get called for each character change
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {        
        countryListTableView?.reloadData()
    }
    
    /**
     This delegate Method returns the keyboard on selection of keyboard Done button
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        countryListSearchBar?.resignFirstResponder()
    }
}
