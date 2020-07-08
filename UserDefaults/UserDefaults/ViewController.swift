//
//  ViewController.swift
//  temp
//
//  Created by Jelani Denis on 7/2/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        
        //basic types
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseTouchID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set(Double(0.5), forKey: "Double")
        
        //advanced types
        defaults.set("Example", forKey: "String")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "Array")

        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "Dict")
        
        defaults.set(Date(), forKey: "LastRun")
        
        //reading values
        defaults.integer(forKey: "Age") //returns an integer, or 0 if none.
        defaults.bool(forKey: "UseTouchID") //returns a boolean, or false if none
        defaults.float(forKey: "Pi") //returns a float, or 0.0 if none
        defaults.double(forKey: "Double") //returns a double, or 0.0 if not.
        
        //typecasting object reads
        let savedString = defaults.object(forKey: "String") as? String //returns Any?
        let savedArray = defaults.object(forKey:"Array") as? [String] ?? [String]()
        let savedDict = defaults.object(forKey: "Dict") as? [String:String] ?? [String:String]()
        
    }


}

