//
//  ViewController.swift
//  Project9.5Hangman
//
//  Created by Connor Lee on 09/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var livesLabel: UILabel!
    var hiddenWordLabel: UILabel!
    
    var wordDictionary = [String]()
    var answer = ""
    var currentAnswer = "" {
        didSet {
            hiddenWordLabel.text = currentAnswer
        }
    }
    var lives = 7 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    var usedLetters = [String]()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.textAlignment = .right
        livesLabel.text = "Lives: \(lives)"
        view.addSubview(livesLabel)
        
        hiddenWordLabel = UILabel()
        hiddenWordLabel.translatesAutoresizingMaskIntoConstraints = false
        hiddenWordLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(hiddenWordLabel)
        
        let letterButton = UIButton(type: .system)
        letterButton.translatesAutoresizingMaskIntoConstraints = false
        letterButton.setTitle("Input", for: .normal)
        letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
        view.addSubview(letterButton)
        
        NSLayoutConstraint.activate([
            // top right
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // middle below
            hiddenWordLabel.topAnchor.constraint(equalTo: livesLabel.layoutMarginsGuide.bottomAnchor, constant: 100),
            hiddenWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // below
            letterButton.topAnchor.constraint(equalTo: hiddenWordLabel.layoutMarginsGuide.bottomAnchor, constant: 100),
            letterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
    }
    
    @objc func letterButtonTapped() {
        // alert button with input
        let ac = UIAlertController(title: "Choose a letter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func loadLevel() {
        // Load list of words
        if let wordFileUrl = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: wordFileUrl) {
                // array of words
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                wordDictionary = lines
            }
        }
        startGame()
    }
    
    func submit(_ input: String) {
        // Can only submit one letter at a time
        if input.count > 1 {
            let ac = UIAlertController(title: "Only one letter allowed!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        // Can't use the same letter again
        if usedLetters.contains(input) {
            let ac = UIAlertController(title: "Letter already used!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        usedLetters.insert(input, at: 0)
        
        // Check if letter is in answer
        var updatedAnswer = ""
        for letter in answer {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                updatedAnswer += strLetter
            } else {
                updatedAnswer += "?"
            }
        }
        
        currentAnswer = updatedAnswer
        
        if answer.contains(input) {
            // correct answer
        } else {
            // incorrect answer
            lives -= 1
            
            if lives <= 0 {
                // end game
                let ac = UIAlertController(title: "You lost! No more lives left.", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again?", style: .default, handler: startGame))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "\(input) is incorrect, you lost a life!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                present(ac, animated: true)
            }
        }
        
        if currentAnswer.elementsEqual(answer) {
            let ac = UIAlertController(title: "You won!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again?", style: .default, handler: startGame))
            present(ac, animated: true)
            return
        }
    }
    
    @objc func startGame(action: UIAlertAction! = nil) {
        lives = 7
        answer = ""
        currentAnswer = ""
        usedLetters.removeAll()
        wordDictionary.shuffle()
        answer = wordDictionary[0]
        for _ in 0..<answer.count {
            currentAnswer += "?"
        }
    }
}

