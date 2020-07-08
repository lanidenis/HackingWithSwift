//
//  ViewController.swift
//  Names To Faces
//
//  Created by Jelani Denis on 6/25/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true //allows user to crop picture
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Extract the image from the dictionary that is passed as a parameter.
        
        if let img = info[.editedImage] as? UIImage {
            //Generate a unique filename for it.
            let imgName = UUID().uuidString
            let imgPath = getDocumentsDirectory().appendingPathComponent(imgName)
            
            //Convert it to a JPEG, then write that JPEG to disk.
            if let jpegData = img.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imgPath)
            }
            
            //create new person and add to collection
            let person = Person(name: "unknown", image: imgPath.path)
            people.append(person)
            collectionView.reloadData()
            self.save()
            
            //Dismiss the view controller.
            dismiss(animated: true)
        }
    }
    
    func getDocumentsDirectory() -> URL { //the documents directory for this app
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        //extract the appropriate UIImageView and Name for this Person
        let person = people[indexPath.item]
        cell.imageView.image = UIImage(contentsOfFile: person.image)
        cell.name.text = person.name
        
        //add styling - UIView inherits from CALayer
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        //return cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Update Person Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Update", style: .default) {
            [weak self, weak ac] action in
            self?.update(name: ac?.textFields?[0].text, indexPath: indexPath)
        })
        present(ac, animated: true)
    }
    
    func update(name: String?, indexPath: IndexPath) {
        if let name = name {
            let person = people[indexPath.item]
            person.name = name
            collectionView.reloadData()
            self.save()
        }
    }
    
    func save() {
        //convert object graph for people into Data object
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard //write to disk
            defaults.set(savedData, forKey: "people")
        }
    }
}

