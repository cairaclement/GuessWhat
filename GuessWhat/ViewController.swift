//
//  ViewController.swift
//  GuessWhat
//
//  Created by Cécile Huguet on 20/11/2018.
//  Copyright © 2018 Cécile Huguet. All rights reserved.
//


import UIKit
import Alamofire
import PromiseKit

struct TokenData : Codable {
    var token: String
}

struct RequestData : Codable {
    var data: TokenData
    var status: Int
}

class ViewController: UIViewController {
    
    let emailField: UITextField = UITextField()
    let passwordField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setViewPreferences()
        
        let navView: UIView = self.view.setNav()
        
        let navLabel = UILabel()
        navLabel.text = "GuessWhat"
        navLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navView.addSubviewGrid(navLabel, grid: [4.5, 5.5, 3, 6])
        
        let emailLabel = UILabel()
        emailLabel.setPreferences()
        emailLabel.text = "Email"
        self.view.addSubviewGrid(emailLabel, grid: [1, 3.5, 10, 0.5])
        
        self.emailField.setPreferences()
        self.emailField.keyboardType = UIKeyboardType.emailAddress
        self.emailField.attributedPlaceholder = NSAttributedString(
            string: "firstname.name@company.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubviewGrid(self.emailField, grid: [1, 4, 10, 0.5]) // x, y, width, height
        
        let passwordLabel = UILabel()
        passwordLabel.setPreferences()
        passwordLabel.text = "Password"
        self.view.addSubviewGrid(passwordLabel, grid: [1, 5, 10, 0.5])
        
        self.passwordField.setPreferences()
        self.passwordField.isSecureTextEntry = true
        self.passwordField.attributedPlaceholder = NSAttributedString(
            string: "Compl3xPassw0rD",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.view.addSubviewGrid(self.passwordField, grid: [1, 5.5, 10, 0.5])
        
        let loginButton = UIButton()
        loginButton.setPreferences()
        loginButton.setTitle("LOG IN", for: .normal)
        self.view.addSubviewGrid(loginButton, grid: [3.5, 7, 5, 0.5])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginTapped(tapGestureRecognizer:)))
        loginButton.isUserInteractionEnabled = true
        loginButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func isValidEmail(email: String?) -> Bool {
        guard email != nil else { return false }
        
        // There’s some text before the @
        // There’s some text after the @
        // There’s at least 2 alpha characters after a
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: email)
    }
    
    func getToken(email: String, pwd: String) -> Promise<String> {
        let parameters = ["email": email, "password": pwd]
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        return Promise { seal in
            Alamofire.request("http://edu2.shareyourtime.fr/api/auth/", method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding(), headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        let jsonData = json["data"]! as! NSDictionary
                        let token = jsonData["token"]!
                        seal.fulfill(token as! String)
                    }
                case .failure:
                    seal.reject(response.error!)
                }
            }
        }
    }
    
    @objc func loginTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let emailValue = self.emailField.text! // "!" removes Optional from string
        let passValue = self.passwordField.text!
        
        if (!isValidEmail(email: emailValue)) {
            print("invalid email")
        }
        
        // Authentication
        getToken(email: emailValue, pwd: passValue).done { token in
            Alamofire.request("http://edu2.shareyourtime.fr/api/secret/", headers: ["Authorization": "Bearer \(token)"]).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                } else {
                    print("Invalid token provided")
                }
            }
        }.catch { error in print(error) }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension UIView {

    func addSubviewGrid(_ view: UIView, grid: [CGFloat]) {
        view.frame = CGRect(
            x: self.frame.width / 12 * grid[0],
            y: self.frame.height / 12 * grid[1],
            width: self.frame.width / 12 * grid[2],
            height: self.frame.height / 12 * grid[3]
        )
        self.addSubview(view)
    }
    
    func setViewPreferences() {
        self.backgroundColor = UIColor(red: 0.12, green: 0.73, blue: 0.84, alpha: 1.0)
    }
    
    func setNav() -> UIView {
        let navView: UIView = UIView()
        navView.backgroundColor = UIColor(red: 0.06, green: 0.49, blue: 0.67, alpha: 1)
        self.addSubviewGrid(navView, grid: [0, 0, 12, 1.2])
        return navView
    }
    
    func setNavWithBackBtn() -> [Any?] {
        let navView: UIView = self.setNav()
        let goBackBtn = UIButton()
        
        goBackBtn.setTitle("Go back", for: .normal)
        navView.addSubviewGrid(goBackBtn, grid: [0.5, 5.5, 3, 6])
        
        return [navView, goBackBtn]
    }
}

extension UITextView {
    
    func setPreferences() {
        self.textColor = UIColor(hexString: "#202020")
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.font = .systemFont(ofSize: 16)
        self.autocapitalizationType = .none;
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPreferences() {
        self.textColor = UIColor(hexString: "#202020")
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.setLeftPaddingPoints(amount: 10)
        self.setRightPaddingPoints(amount: 10)
        self.autocapitalizationType = .none;
    }
}

extension UIButton {
    
    func setPreferences() {
        self.backgroundColor = UIColor(hexString: "#202020")
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

extension UILabel {

    func setPreferences() {
        self.font = self.font.withSize(18)
        self.textColor = UIColor(hexString: "#202020")
    }
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255) << 16 | (Int)(g*255) << 8 | (Int)(b*255) << 0
        
        return String(format:"#%06x", rgb)
    }
}

