//
//  CellViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 17/12/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.
//

import UIKit

class CellViewController : UITableViewCell {
    
    override func layoutSubviews() {
        
    }
    
    func prepareView(index: Int) {
        self.contentView.setViewPreferences()
        
        let defaults = UserDefaults.standard
        
        if let history: [[String: Any]] = defaults.array(forKey: "history") as? [[String : Any]] {
            let finderPlayerLabel = UILabel()
            finderPlayerLabel.text = "Players: \(history[index]["finderPlayer"]!) and \(history[index]["answerPlayer"]!)"
            finderPlayerLabel.setPreferences()
            self.contentView.addSubviewGrid(finderPlayerLabel, grid: [0.5, 2, 11, 2.5])
        
            let wordLabel = UILabel()
            wordLabel.text = "'\(history[index]["wordToGuess"]!)' was the word to guess"
            wordLabel.setPreferences()
            self.contentView.addSubviewGrid(wordLabel, grid: [0.5, 5, 11, 2.5])
            
            let answerCountLabel = UILabel()
            answerCountLabel.text = "\(history[index]["answerCount"]!) questions were asked"
            answerCountLabel.setPreferences()
            self.contentView.addSubviewGrid(answerCountLabel, grid: [0.5, 8, 11, 2.5])
        }
    }
}
