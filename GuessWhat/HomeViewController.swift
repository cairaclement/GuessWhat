//
//  HomeViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 26/11/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let playerOneInput: UITextField = UITextField()
    let playerTwoInput: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setViewPreferences()
        
        let navView: UIView = self.view.setNav()
        
        let navLabel = UILabel()
        navLabel.text = "GuessWhat"
        navLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navView.addSubviewGrid(navLabel, grid: [4.5, 5.5, 3, 6])
        
        let historyBtn = UIButton()
        historyBtn.setTitle("History", for: .normal)
        navView.addSubviewGrid(historyBtn, grid: [9, 5.5, 3, 6])
        historyBtn.addTarget(self, action: #selector(goToHistory(tapGestureRecognizer:)), for: .touchUpInside)
        
        let topText = UILabel()
        topText.text = "Play now"
        topText.setPreferences()
        topText.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubviewGrid(topText, grid: [4.5, 2.5, 10, 0.5])
        
        let playerOneText = UILabel()
        playerOneText.text = "Player 1 (owner of this phone)"
        playerOneText.setPreferences()
        self.view.addSubviewGrid(playerOneText, grid: [1, 4, 10, 0.5])

        playerOneInput.setPreferences()
        playerOneInput.attributedPlaceholder = NSAttributedString(
            string: "James",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubviewGrid(playerOneInput, grid: [1, 4.5, 10, 0.5])
        
        let playerTwoText = UILabel()
        playerTwoText.text = "Player 2"
        playerTwoText.setPreferences()
        self.view.addSubviewGrid(playerTwoText, grid: [1, 5.5, 10, 0.5])
        
        playerTwoInput.setPreferences()
        playerTwoInput.attributedPlaceholder = NSAttributedString(
            string: "Mary",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubviewGrid(playerTwoInput, grid: [1, 6, 10, 0.5])
        
        let buttonLetsGo = UIButton()
        buttonLetsGo.setPreferences()
        buttonLetsGo.setTitle("LET'S GO!", for: .normal)
        self.view.addSubviewGrid(buttonLetsGo, grid: [3.5, 7.5, 5, 0.5])
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonLetsGo(tapGestureRecognizer:)))
        buttonLetsGo.isUserInteractionEnabled = true
        buttonLetsGo.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let FormViewController = segue.destination as? FormViewController {
            FormViewController.players = sender as? [String]
        }
    }
    
    @objc func goToHistory(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "HistoryViewController", sender: nil)
    }

    @objc func buttonLetsGo(tapGestureRecognizer: UITapGestureRecognizer) {
        if playerOneInput.text != "" || playerTwoInput.text != "" {
            let players = [playerOneInput.text, playerTwoInput.text]
            self.performSegue(withIdentifier: "FormViewController", sender: players)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
