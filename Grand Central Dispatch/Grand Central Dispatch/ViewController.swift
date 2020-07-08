//
//  ViewController.swift
//  Whitehouse Petitions
//
//  Created by Jelani Denis on 6/11/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    var petitions = [Petition]()
    var results = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //customized info icon for credits
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showCredits), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        //customized search bar view for nav bar
        let searchBar : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        
        //determine correct data source for this tab
        let urlString: String

        //GCD complained that reading a UI value even must be done on main thread
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        //run fetchJSON in background, force owning class to execute/clean up code
        performSelector(inBackground: #selector(fetchJSON), with: urlString)
    }
    
    @objc func fetchJSON(urlString: String) {
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) { //blocking call
                //this will lock up the UI until completion
                self.parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            results = petitions
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text! != "" {
            var newResults = [Petition]()
            newResults = petitions.filter({ (petition: Petition) -> Bool in
                let title = petition.title.contains(searchBar.text!)
                let body = petition.body.contains(searchBar.text!)
                return title || body
            })
            results = newResults
            tableView.reloadData()
        }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data in this tab comes from We The People API of the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: noOpHandler))
        present(ac, animated: true)
    }
    func noOpHandler(action: UIAlertAction?) {
        return
    }
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = results[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            results = jsonPetitions.results
            
            DispatchQueue.main.async { //ui work must be done on main thread
                self.tableView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.showError()
            }
        }
    }


}

