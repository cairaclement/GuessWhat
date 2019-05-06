//
//  FormViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 26/11/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var players: [String]?
    var pickerData: [String] = [String]()
    var finderPlayerPicker = UIPickerView()
    var wordField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setViewPreferences()
        
        let nav = self.view.setNavWithBackBtn()
        let navView: UIView = nav[0] as! UIView
        let goBackBtn: UIButton = nav[1] as! UIButton
        goBackBtn.addTarget(self, action: #selector(goBack(tapGestureRecognizer:)), for: .touchUpInside)
        
        let navLabel = UILabel()
        navLabel.text = "Prerequisites"
        navLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navView.addSubviewGrid(navLabel, grid: [4.4, 5.5, 4, 6])

        let title = UILabel()
        title.text = "Set the game :)"
        title.setPreferences()
        title.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubviewGrid(title, grid: [3.5, 2.5, 5, 0.5])
        
        let pickerLabel = UILabel()
        pickerLabel.text = "Select the player who will try to find the word:"
        pickerLabel.setPreferences()
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0
        self.view.addSubviewGrid(pickerLabel, grid: [1, 4, 10, 1])
        
        finderPlayerPicker.backgroundColor = .white
        finderPlayerPicker.layer.cornerRadius = 5
        finderPlayerPicker.delegate = self
        finderPlayerPicker.dataSource = self
        pickerData = players!
        self.view.addSubviewGrid(finderPlayerPicker, grid: [1, 5, 10, 0.5]) // x, y, width, height
        
        let wordLabel = UILabel()
        wordLabel.text = "Choose the word to be guessed:"
        wordLabel.setPreferences()
        self.view.addSubviewGrid(wordLabel, grid: [1, 6, 10, 0.5])
        
        wordField.setPreferences()
        wordField.attributedPlaceholder = NSAttributedString(
            string: "beautiful",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubviewGrid(wordField, grid: [1, 6.5, 10, 0.5])
        
        let playButton = UIButton()
        playButton.setPreferences()
        playButton.setTitle("PLAY", for: .normal)
        self.view.addSubviewGrid(playButton, grid: [3.5, 8, 5, 0.5])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginTapped(tapGestureRecognizer:)))
        playButton.isUserInteractionEnabled = true
        playButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @objc func goBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let wordToGuess = wordField.text, (wordToGuess != "") {
            let selectedPlayer = pickerData[finderPlayerPicker.selectedRow(inComponent: 0)]
            var otherPlayer = ""
            
            for data in pickerData {
                if data != selectedPlayer {
                    otherPlayer = data
                }
            }
            
            self.performSegue(
                withIdentifier: "GuessViewController",
                sender: [wordToGuess.lowercased(), selectedPlayer, otherPlayer
            ])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let guessViewController = segue.destination as? GuessViewController {
            let array = sender as! [String]
            guessViewController.wordToGuess = array[0] as String
            guessViewController.finderPlayer = array[1] as String
            guessViewController.answerPlayer = array[2] as String
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
