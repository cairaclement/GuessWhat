//
//  HistoryViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 11/12/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let defaults = UserDefaults.standard
        if let history = defaults.array(forKey: "history") {
            return history.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CellViewController
        
        cell.prepareView(index: indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setViewPreferences()
        
        let nav = self.view.setNavWithBackBtn()
        let navView: UIView = nav[0] as! UIView
        let goBackBtn: UIButton = nav[1] as! UIButton
        goBackBtn.addTarget(self, action: #selector(goBack(tapGestureRecognizer:)), for: .touchUpInside)
        
        let navLabel = UILabel()
        navLabel.text = "History"
        navLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navView.addSubviewGrid(navLabel, grid: [5, 5.5, 3, 6])
        
        tableView = UITableView(frame: self.view.frame)
        tableView.register(CellViewController.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0.12, green: 0.73, blue: 0.84, alpha: 1.0)
        self.view.addSubviewGrid(tableView, grid: [0, 1.2, 12, 12])
    }
    
    @objc func goBack(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

