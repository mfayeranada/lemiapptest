//
//  SearchViewController.swift
//  LemiAppTest
//
//  Created by Meredith Faye Ranada on 11/05/2019.
//  Copyright © 2019 Meredith Faye Ranada. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    
    //MARK: Properties
    @IBOutlet weak var cityTableView: UITableView!
    var cities = [City]()
    var currentCityArray = [City]()
    var fetchedResults = [JSON]()
    var dataArray = [String]()
    var filteredArray = [String]()
    var valueToPass: String!
    let urlToLoad = "https://lemi.travel/api/v5/cities"
    let urlToSearch = "https://lemi.travel/api/v5/cities?q=lon"
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        cityTableView.frame = CGRect(x: 0, y: barHeight, width: self.view.frame.width, height: self.view.frame.height)
        cityTableView.dataSource = self
        cityTableView.delegate = self
        loadData()
        setupSearchBar()
        present(searchController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchController.isActive = true
        self.definesPresentationContext = true
        didPresentSearchController(searchController)
    }
    
    
    @IBAction func tapToSelect(gestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "TapToSelectView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowSelectCityView") {
            let tapToSelectVC = segue.destination as? TapToSelectViewController
            tapToSelectVC?.valueToPass = valueToPass
        }
    }
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {
        Alamofire.request(url).responseData { responseData in
            guard let imageData = responseData.data else {
                completionHandler(nil, .failure)
                return
            }
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil, .failure)
                return
            }
            completionHandler(image, .success)
        }
    }
    
    
    //MARK: Load API
    
    func loadData() {
        let url = URL(string: urlToLoad)
        guard let jsonData = url
            else {
                print("Data not found")
                return
        }
        guard let data = try? Data(contentsOf: jsonData) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        guard let dictionary = json as? [[String:Any]] else { return }
        cities = dictionary.compactMap { return City($0) }
        self.cityTableView.reloadData()
    }
    
    func searchData(searchText: String, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {
        let url = URL(string: urlToSearch)
        guard let jsonData = url
            else {
                print("Data not found")
                return
        }
        guard let data = try? Data(contentsOf: jsonData) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        guard let dictionary = json as? [[String:Any]] else { return }
        cities = dictionary.compactMap { return City($0) }
        self.cityTableView.reloadData()
    }
    
   
    //MARK: Search Controller
    
    func setupSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city"
        definesPresentationContext = true
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.done, target: self, action: #selector(tapToSelect(gestureRecognizer:)))
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty  else { currentCityArray = cities; return }
        currentCityArray = cities.filter({ city -> Bool in
            return city.name?.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil
        })
        cityTableView.reloadData()
        self.searchResults(for: searchText)
    }
    
    func searchResults(for text: String) {
        searchData(searchText: text, completionHandler: { results, error in
            if case .failure = error {
                return
            }
            guard let results = results, !results.isEmpty else {
                return
            }
            self.fetchedResults = results
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredArray = dataArray.filter({ (city) -> Bool in
            let cityText: NSString = city as NSString
            return (cityText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
        })
        cityTableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchController.searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchController.searchBar.showsCancelButton = false
        return true
    }
    
    
    //MARK: Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = cityTableView.indexPathForSelectedRow
        let currentCell = cityTableView.cellForRow(at: indexPath!) as! CityTableViewCell
        let valueString = UILabel()
        valueString.text = "You selected: "
        valueToPass = valueString.text! + currentCell.cityNameLbl.text!
        performSegue(withIdentifier: "ShowSelectCityView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        cell.cityNameLbl?.text = city.name
        cell.citySubtitleLbl?.text = city.subtitle
        
        if let imageUrl = city.banner {
            self.fetchImage(url: imageUrl, completionHandler: { image, _ in
                cell.cityImageView.image = image
            })
        } else {
            
        }
        return cell
    }
    
}

enum NetworkError: Error {
    case failure
    case success
}
