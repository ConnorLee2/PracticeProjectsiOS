//
//  ViewController.swift
//  Pairs
//
//  Created by Connor Lee on 07/08/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var pairList = [Pair]()
    var level = 1
    var matchedItems = 0
    
    var scoreLabel: UILabel!
    var titleLabel: UILabel!
    var pairButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "chalkduster", size: 52)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "PAIRS"
        view.addSubview(titleLabel)
        
        scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 36)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        score = 0
        view.addSubview(scoreLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 1000),
            buttonsView.heightAnchor.constraint(equalToConstant: 400),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 250
        let height = 100
        
        for row in 0..<4 {
            for column in 0..<4 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                letterButton.setTitle("Hidden", for: .normal)
                letterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                pairButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadLevel()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Show tapped card
        sender.isSelected = true
        activatedButtons.append(sender)
        
        // Run the check 1.5 seconds later
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.checkPairs()
        }
        
    }
    
    func checkPairs() {
        if activatedButtons.count == 2 {
            // Check if they match a pair in the pair list
            let pair1 = activatedButtons[0].title(for: .selected) ?? ""
            let pair2 = activatedButtons[1].title(for: .selected) ?? ""
            let pair = Pair(pair1: pair1, pair2: pair2)
            let pairReversed = Pair(pair1: pair2, pair2: pair1)
            
            // Check if we have a match
            if pairList.contains(pair) || pairList.contains(pairReversed) {
                // If they do match, remove from the game, increase score
                for button in activatedButtons {
                    button.isHidden = true
                }
                activatedButtons.removeAll()
                score += 5
                matchedItems += 1
                
                if matchedItems % 8 == 0 {
                    let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                    present(ac, animated: true)
                }
                
            } else {
                // Don't match, reset game state
                for button in activatedButtons {
                    button.isSelected = false
                }
                activatedButtons.removeAll()
                score -= 1
            }
        }
    }
    
    func levelUp (action: UIAlertAction) {
        // todo
    }

    func loadLevel() {
        // Load level file
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.remove(at: lines.count - 1) // remove the final \n
                lines.shuffle()
                
                for (_, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let pair = Pair(pair1: parts[0], pair2: parts[1])
                    pairList.append(pair)
                }
            }
        }
        
        // Make pair list into a list of strings
        var answerList = [String]()
        
        for i in 0..<pairList.count {
            let answer1 = pairList[i].pair1
            let answer2 = pairList[i].pair2
            answerList.append(answer1)
            answerList.append(answer2)
        }
        
        // Update card buttons
        pairButtons.shuffle()
        answerList.shuffle()
        
        if pairButtons.count == answerList.count {
            for i in 0 ..< pairButtons.count {
                pairButtons[i].setTitle(answerList[i], for: .selected)
            }
        }
    }

}

