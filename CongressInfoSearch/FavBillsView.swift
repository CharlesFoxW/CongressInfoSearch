//
//  FavBillsView.swift
//  CongressInfoSearch
//
//  Created by Clarence Wang on 11/26/16.
//  Copyright © 2016 Clarence Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavBillsView: UIViewController {
    
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
        self.tableView.registerCellNib(BillsTableViewCell.self)
        
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
        let rawArray = StoredFavorites.favBillList
        self.filteredArray = rawArray.filter() { json in
            return json["bill_id"].stringValue.lowercased().contains(searchText.lowercased())
        }
        self.tableView.reloadData()
    }
    
}

extension FavBillsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BillsTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "BillDetailsView", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "BillDetailsView") as! BillDetailsView
        if searchController.isActive && searchController.searchBar.text != "" {
            subContentsVC.thisJson = self.filteredArray[indexPath.row]
        } else {
            subContentsVC.thisJson = StoredFavorites.favBillList[indexPath.row]
        }
        self.parent?.navigationItem.title = nil
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
}

extension FavBillsView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredArray.count
        }
        return StoredFavorites.favBillList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: BillsTableViewCell.identifier) as! BillsTableViewCell
        let data: BillsTableViewCellData
        if searchController.isActive && searchController.searchBar.text != "" {
            data = BillsTableViewCellData(text: self.filteredArray[indexPath.row]["official_title"].stringValue, id: self.filteredArray[indexPath.row]["bill_id"].stringValue, time: self.filteredArray[indexPath.row]["introduced_on"].stringValue)
        } else {
            data = BillsTableViewCellData(text: StoredFavorites.favBillList[indexPath.row]["official_title"].stringValue, id: StoredFavorites.favBillList[indexPath.row]["bill_id"].stringValue, time: StoredFavorites.favBillList[indexPath.row]["introduced_on"].stringValue)
        }
        cell.setData(data)
        return cell
    }
}

extension FavBillsView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
