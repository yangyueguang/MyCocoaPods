//
//  ViewController.swift
import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       let us = User.init(name: "sd", pwd: "dk", account: "ds")
        print(us.account!)
        
    }
}

