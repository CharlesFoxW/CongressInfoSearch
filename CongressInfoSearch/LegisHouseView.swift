//
//  LegisHouseView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/23/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class LegisHouseView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var json: JSON = []
    var sortedJson: JSON = []
    var filteredArray: [JSON] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var isDisplayingSearchBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Register the cells first:
        self.tableView.registerCellNib(LegisTableViewCell.self)
        
        let parameters: Parameters = ["catagory": "legis_house"]
        SwiftSpinner.show("Fetching Data ...")
        Alamofire.request("http://clsfox.us-west-2.elasticbeanstalk.com/index.php",
                          parameters: parameters).validate().responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                print("Validation Successful")
                                self.json = JSON(value)
                                let rawArray = self.json["results"].arrayValue
                                let sortedArray = rawArray.sorted(by: {
                                    $0["last_name"].stringValue == $1["last_name"].stringValue ?
                                        $0["first_name"].stringValue < $1["first_name"].stringValue
                                        : $0["last_name"].stringValue < $1["last_name"].stringValue
                                })
                                self.sortedJson = JSON(sortedArray)
                                
                                // Reload the cells:
                                self.tableView.reloadData()
                                SwiftSpinner.hide()
                            case .failure(let error):
                                print("Not Successful")
                                print(error)
                                SwiftSpinner.hide()
                            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Legislators"
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(toggleSearchBar(sender:)))
        searchController.isActive = false
        isDisplayingSearchBar = false
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func toggleSearchBar(sender: UIBarButtonItem) {
        if isDisplayingSearchBar {
            self.parent?.navigationItem.titleView = nil
            self.parent?.navigationItem.rightBarButtonItem?.image = UIImage(named: "Search")
            isDisplayingSearchBar = false
            searchController.isActive = false
        } else {
            self.parent?.navigationItem.titleView = self.searchController.searchBar
            self.parent?.navigationItem.rightBarButtonItem?.image = UIImage(named: "Cancel")
            isDisplayingSearchBar = true
        }
    }
    
    fileprivate func filterContentForSearchText(searchText: String, scope: String = "All") {
        let rawArray = self.sortedJson.arrayValue
        self.filteredArray = rawArray.filter() { json in
            return json["first_name"].stringValue.lowercased().contains(searchText.lowercased())
        }
        self.tableView.reloadData()
    }
    
}

extension LegisHouseView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisDetailsView", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailsView") as! LegisDetailsView
        if searchController.isActive && searchController.searchBar.text != "" {
            subContentsVC.thisJson = self.filteredArray[indexPath.row]
        } else {
            subContentsVC.thisJson = self.sortedJson[indexPath.row]
        }
        self.parent?.navigationItem.title = nil
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

extension LegisHouseView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredArray.count
        }
        return self.sortedJson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier) as! LegisTableViewCell
        var data = LegisTableViewCellData(imageUrl: "", text: "", detailText: "")
        if searchController.isActive && searchController.searchBar.text != "" {
            data = LegisTableViewCellData(imageUrl: "https://theunitedstates.io/images/congress/original/" +
                self.filteredArray[indexPath.row]["bioguide_id"].stringValue + ".jpg",
                                          text: self.filteredArray[indexPath.row]["last_name"].stringValue + ", "
                                            + self.filteredArray[indexPath.row]["first_name"].stringValue,
                                          detailText: self.filteredArray[indexPath.row]["state_name"].stringValue)
        } else {
            data = LegisTableViewCellData(imageUrl: "https://theunitedstates.io/images/congress/original/" +
                self.sortedJson[indexPath.row]["bioguide_id"].stringValue + ".jpg",
                                          text: self.sortedJson[indexPath.row]["last_name"].stringValue + ", "
                                            + self.sortedJson[indexPath.row]["first_name"].stringValue,
                                          detailText: self.sortedJson[indexPath.row]["state_name"].stringValue)
        }
        
        cell.setData(data)
        return cell
    }
}

extension LegisHouseView: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}

extension LegisHouseView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

