//
//  ViewController.swift
//  Seven Swifty Words
//
//  Created by Jelani Denis on 6/15/20.
//  Copyright © 2020 Jelani Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //create and add scoreLabel
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        //create and add cluesLabel
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.textAlignment = .left
        cluesLabel.text = "Clues"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0 //wrap over as many lines as necessary
        view.addSubview(cluesLabel)
        
        //create and add answersLabel
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.textAlignment = .left
        answersLabel.text = "Answers"
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0 //wrap over as many lines as necessary
        view.addSubview(answersLabel)
        
        //create and add currentAnswer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)

        //create and add submit button
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        view.addSubview(submit)
        
        //event handler for submit
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        //create and add clear button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        view.addSubview(clear)
        
        //event handler for clear
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        //create and add buttonsView container
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(buttonsView)
        
        //layout stretching/shrinking priorities
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            clear.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        //create and add all 20 word segment buttons
        let width = 150
        let height = 80
        for row in 0...3 {
            for col in 0...4 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.setTitle("WWW", for: .normal)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height) //relative to topleft of parent view???
                button.frame = frame
                buttonsView.addSubview(button)
                letterButtons.append(button)
                
                //event handler for button
                button.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        // Now configure the buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for (index, button) in letterButtons.enumerated() {
                button.setTitle(letterBits[index], for: .normal)
            }
        }
    }
    
    @objc func lettersTapped(_ sender: UIButton) {
        currentAnswer.text = (currentAnswer.text ?? "") + (sender.currentTitle ?? "")
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        if let answer = currentAnswer.text {
            if let position = solutions.firstIndex(of: answer) {
                activatedButtons.removeAll()
                if var hints = answersLabel.text?.components(separatedBy: "\n") {
                    hints[position] = answer
                    answersLabel.text = hints.joined(separator: "\n")
                    score += 1
                    currentAnswer.text = ""
                    
                    if score % 7 == 0 {
                        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                        present(ac, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for button in letterButtons {
            button.isHidden = false
        }
        score = 0
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = nil
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    
    
    

}

