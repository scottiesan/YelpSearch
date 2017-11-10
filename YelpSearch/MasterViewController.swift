
//
//  MasterViewController.swift
//  TableV
//
//  Created by HO, SCOTT on 11/9/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    var searchController = UISearchController(searchResultsController: nil)
    var detailViewController: DetailViewController? = nil
    var searches = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Load searches
        let defaults = UserDefaults.standard
        if let searchHistory = defaults.stringArray(forKey: "searches"){
            searches = searchHistory
        }
        
        // Setup the Search Controller
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Backgrounding
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationWillResignActive, object: nil)
}
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            var searchString:String = ""
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                searchString = searches[indexPath.row]
            } else{
                searchString = searches[0]
            }
            controller.searchTerm = searchString
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = searches[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            searches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

// Search
extension MasterViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searches.insert(searchBar.text!, at: 0)

        self.performSegue(withIdentifier: "showDetail", sender: self)
        self.tableView.reloadData()

    }
}

// Simple saving searches
extension MasterViewController{
    @objc func willResignActive(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.set(searches, forKey: "searches")    }
}
