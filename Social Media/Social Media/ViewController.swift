//
//  ViewController.swift
//  Storm Viewer
//
//  Created by Jelani Denis on 5/25/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController { //UIViewController is Apple’s default screen type
    var pictures = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Storm Viewer"

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        print(pictures)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //interesting, we differentiate functions by their parameter names
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //cell.textLabel?.text = pictures[indexPath.row]
        let length = pictures.count
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(length)"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        //load DetailViewController from Storyboard
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController
        if let vc = detailViewController { //set its selectedImage property, and show it on screen
            vc.selectedImage = pictures[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
    }


        
    }


}

