//
//  ViewController.swift
//  Project2GuessTheFlag
//
//  Created by Connor Lee on 25/06/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    let savedScoreKey = "savedScore"
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        numQuestions += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // .normal is the standard view of a button, others like highlighted
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Guess \(countries[correctAnswer].uppercased()) | Current score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        // show one final alert if they have answered 10 questions
        if numQuestions == 10 {
            let defaults = UserDefaults.standard
            
            let savedScore = defaults.integer(forKey: savedScoreKey)
            
            let message = "Your final score is \(score)"
            
            if score > savedScore {
                title = "New high score!"
                defaults.set(score, forKey: savedScoreKey)
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            present(ac, animated: true)
        } else {
            var message: String
            // if you choose the wrong flag, tell them their mistake
            if title == "Wrong" {
                message = "Your score is \(score). \n The correct flag was flag \(correctAnswer + 1)"
            } else {
                message = "Your score is \(score)"
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }
        
        
    }
    
}

