//
//  ViewController.swift
//  Auto Layout B
//
//  Created by Jelani Denis on 6/11/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var viewsDictionary : [String: Any] = [:]
    var labelList : [UILabel] = []
    let metrics = ["labelHeight": 88]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = [UIColor.red, UIColor.cyan, UIColor.yellow, UIColor.green, UIColor.orange]
        let text = ["THESE","ARE","SOME","AWESOME","LABELS"]
        
        for i in 0...4 {
            let label = UILabel()
            
            //remove auto constraints
            label.translatesAutoresizingMaskIntoConstraints = false
            
            //set design properties
            label.backgroundColor = colors[i]
            label.text = text[i]
            label.sizeToFit()
            
            //add to our view
            view.addSubview(label)
            viewsDictionary["label\(i+1)"] = label
            labelList.append(label)
        }

        
//        //horizontal constraints
//        for i in 0...4 {
//            view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[label\(i+1)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        //vertical constraints
//        let vfl = "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|"
//        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: metrics, views: viewsDictionary))
        
        //alternative method
        //
        //same functionality using anchors
        print("\(view.safeAreaInsets.bottom)")
        print("\(view.safeAreaInsets.top)")
        print("\(view.safeAreaLayoutGuide.bottomAnchor)")
        print("\(view.safeAreaLayoutGuide.topAnchor)")
        var previous: UILabel?
        for label in labelList {
            
            //width (horizontal) - safe area
            label.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            
            //height - safe area
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
            label.heightAnchor.constraint(equalTo: label.heightAnchor, constant: -10)
            
            //position (vertical)
            if let previous = previous {
                // we have a previous label – create a height constraint
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                // this is the first label
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            // set the previous label to be the current one, for the next loop iteration
            previous = label
        }

    }


}

