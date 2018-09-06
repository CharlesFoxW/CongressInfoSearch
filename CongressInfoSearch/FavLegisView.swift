//
//  FavLegisView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavLegisView: UIViewController {
    
    var filteredArray: [JSON] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var isDisplayingSearchBar: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Register the cells first:
        self.tableView.registerCellNib(LegisTableViewCell.self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "Favorites"
        self.parent?.navigationItem.titleView = nil
        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(toggleSearchBar(sender:)))
        searchController.isActive = false
        isDisplayingSearchBar = false
        self.tableView.reloadData()
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
        let rawArray = StoredFavorites.favLegisList
        self.filteredArray = rawArray.filter() { json in
            return json["first_name"].stringValue.lowercased().contains(searchText.lowercased())
        }
        self.tableView.reloadData()
    }
    
}

extension FavLegisView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LegisTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LegisDetailsView", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "LegisDetailsView") as! LegisDetailsView
        if searchController.isActive && searchController.searchBar.text != "" {
            subContentsVC.thisJson = self.filteredArray[indexPath.row]
        } else {
            subContentsVC.thisJson = StoredFavorites.favLegisList[indexPath.row]
        }
        self.parent?.navigationItem.title = nil
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
}

extension FavLegisView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredArray.count
        }
        return StoredFavorites.favLegisList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LegisTableViewCell.identifier) as! LegisTableViewCell
        let data: LegisTableViewCellData
        if searchController.isActive && searchController.searchBar.text != "" {
            data = LegisTableViewCellData(imageUrl: "https://theunitedstates.io/images/congress/original/"
                + self.filteredArray[indexPath.row]["bioguide_id"].stringValue + ".jpg",
                text: self.filteredArray[indexPath.row]["first_name"].stringValue + " "
                + self.filteredArray[indexPath.row]["last_name"].stringValue,
                detailText: self.filteredArray[indexPath.row]["state_name"].stringValue)
        } else {
            data = LegisTableViewCellData(imageUrl: "https://theunitedstates.io/images/congress/original/"
                + StoredFavorites.favLegisList[indexPath.row]["bioguide_id"].stringValue + ".jpg",
                text: StoredFavorites.favLegisList[indexPath.row]["first_name"].stringValue + " "
                + StoredFavorites.favLegisList[indexPath.row]["last_name"].stringValue,
                detailText: StoredFavorites.favLegisList[indexPath.row]["state_name"].stringValue)
        }
        cell.setData(data)
        return cell
    }
}

extension FavLegisView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
