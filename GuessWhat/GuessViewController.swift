//
//  GuessViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 26/11/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.
//

import UIKit

class GuessViewController: UIViewController, UITextViewDelegate {
    
    // Data received from previous form
    var wordToGuess: String?
    var finderPlayer: String?
    var answerPlayer: String?
    
    let questionField: UITextView = UITextView()
    let guessWordField: UITextField = UITextField()
    let bottomView: UIView = UIView()
    let historyScrollView: UIScrollView = UIScrollView()
    
    var answerCount: Int = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setViewPreferences()
        
        let nav = self.view.setNavWithBackBtn()
        let navView: UIView = nav[0] as! UIView
        let goBackBtn: UIButton = nav[1] as! UIButton
        goBackBtn.addTarget(self, action: #selector(goBack(tapGestureRecognizer:)), for: .touchUpInside)
        
        let navLabel = UILabel()
        navLabel.text = "Guess the word"
        navLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navView.addSubviewGrid(navLabel, grid: [4, 5.5, 4, 6])
        
        let playerLabel = UILabel()
        playerLabel.setPreferences()
        playerLabel.text = "\(finderPlayer!), guess the word!"
        self.view.addSubviewGrid(playerLabel, grid: [1, 1.4, 10, 0.5])
        
        questionField.setPreferences()
        self.view.addSubviewGrid(questionField, grid: [1, 2, 10, 1])
        
        let yesButton = UIButton()
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setPreferences()
        yesButton.addTarget(self, action: #selector(askQuestion), for: .touchUpInside)
        self.view.addSubviewGrid(yesButton, grid: [1, 3.1, 1.4, 0.5])
        
        let noButton = UIButton()
        noButton.setTitle("No", for: .normal)
        noButton.setPreferences()
        noButton.addTarget(self, action: #selector(askQuestion), for: .touchUpInside)
        self.view.addSubviewGrid(noButton, grid: [2.6, 3.1, 1.4, 0.5])
        
        let idkButton = UIButton()
        idkButton.setTitle("Don't know", for: .normal)
        idkButton.setPreferences()
        idkButton.addTarget(self, action: #selector(askQuestion), for: .touchUpInside)
        self.view.addSubviewGrid(idkButton, grid: [4.2, 3.1, 3.4, 0.5])
        
        self.view.addSubviewGrid(historyScrollView, grid: [1, 4, 10, 6.5])
        
        bottomView.backgroundColor = UIColor(red: 0.06, green: 0.49, blue: 0.67, alpha: 1)
        self.view.addSubviewGrid(bottomView, grid: [0, 11, 12, 1])
        
        guessWordField.setPreferences()
        guessWordField.attributedPlaceholder = NSAttributedString(
            string: "Guess word directly",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        bottomView.addSubviewGrid(guessWordField, grid: [1, 3, 8, 6])
        
        let guessWordBtn = UIButton()
        guessWordBtn.setPreferences()
        guessWordBtn.setTitle("OK", for: .normal)
        bottomView.addSubviewGrid(guessWordBtn, grid: [9.5, 3, 1.5, 6])
        guessWordBtn.addTarget(self, action: #selector(askWord), for: .touchUpInside)
    }
    
    @objc func goBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var history = ""
    let newLabel = UILabel()
    var scrollViewHeight = 100
    
    @objc func askWord(sender: UIButton) {
        if let word = guessWordField.text, (word != "") {
            if (word == wordToGuess! || word.lowercased() == wordToGuess!) {
                
                // set data to store
                let defaults = UserDefaults.standard
                let game: [String: Any] = [
                    "finderPlayer": finderPlayer!,
                    "answerPlayer": answerPlayer!,
                    "wordToGuess": word.lowercased(),
                    "answerCount": answerCount
                ]
                
                // store data in app
                if let historyData = defaults.array(forKey: "history") {
                    print(historyData) // Another String Value
                    var newHistory = historyData
                    newHistory.append(game)
                    print("new history", newHistory)
                    UserDefaults.standard.removeObject(forKey: "history")
                    UserDefaults.standard.set(newHistory, forKey: "history")
                } else {
                    defaults.set([game], forKey: "history")
                }
                
                self.performSegue(withIdentifier: "SummaryViewController", sender: [
                    word.lowercased(),
                    finderPlayer!,
                    answerPlayer!,
                    answerCount
                ])
            }
        }
    }
    
    @objc func askQuestion(sender: UIButton) {
        if let question = questionField.text, (question != "") {
            let question: String = questionField.text!
            let answer = sender.title(for: .normal)
            
            historyScrollView.contentSize = CGSize(width: historyScrollView.frame.size.width, height: CGFloat(scrollViewHeight))
            questionField.text = ""
            newLabel.text = ""
            
            newLabel.numberOfLines = 0
            scrollViewHeight = scrollViewHeight + 20
            answerCount = answerCount + 1
            
            history += question + " - " + answer! + "\n"
            newLabel.text = history
            
            historyScrollView.addSubviewGrid(newLabel, grid: [0.3, 0.3, 12, 12])
            newLabel.sizeToFit()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SummaryViewController = segue.destination as? SummaryViewController {
        let array = sender as! [Any]
            SummaryViewController.wordToGuess = array[0] as! String
            SummaryViewController.finderPlayer = array[1] as! String
            SummaryViewController.answerPlayer = array[2] as! String
            SummaryViewController.answerCount = array[3] as! Int
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
