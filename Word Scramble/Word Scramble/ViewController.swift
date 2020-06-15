//
//  ViewController.swift
//  Word Scramble
//
//  Created by Jelani Denis on 6/5/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWordsCount : Int = 0
    var usedWords = [String]()
    var usedWordsDict : [String:Bool] = [:]
    var base : [Character : Int] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // add navbar button to show prompt
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

        // add navbar button to start new game
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        //extract all words from file
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        //choose new word, clear old answers
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        usedWordsDict = [:]
        usedWordsCount = 0
        tableView.reloadData()
        
        //reset base dict
        base = [:]
        for letter in title! {
            base[letter] = (base[letter] ?? 0) + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Submit An Answer", message: "Enter an anagram for the word \(title!)", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { //replace handle with trailing closure syntax
            [weak self, weak ac] action in // avoid strong reference cycles
            guard let userInput = ac?.textFields![0].text?.lowercased() else {
                //guard control flow keyword only protects against nil
                //not empty string
                return
            }
            self?.submit(answer: userInput, ac: ac)
        })
        present(ac, animated: true)
    }
    
    func submit(answer: String, ac: UIAlertController?) {
        if isReal(word: answer) && isOriginal(word: answer) && isPossible(word: answer) {
            usedWordsDict[answer] = false
            usedWords.append(answer)
            //insert at end, rather than refreshing all rows with reloadData()
            let indexPath = IndexPath(row: usedWordsCount - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else if ac != nil {
            ac!.title = "Invalid Submission"
            present(ac!, animated: true)
        }
    }
    
//    func isPossible(word: String) -> Bool {
//        var test : [ Character : Int ] = [:]
//        for letter in word {
//            test[letter] = (test[letter] ?? 0) + 1
//        }
//        var isPossible = true
//        for (letter, count) in test {
//            if base[letter] != nil && base[letter]! >= count {
//                continue
//            } else {
//                isPossible = false
//                break
//            }
//        }
//        return isPossible
//    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        //return !usedWords.contains(word)
        return usedWordsDict[word] ?? true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound && word.count > 0
    }
    
}

