//
//  ViewController.swift
//  DoguiApp
//
//  Created by Janis on 12/10/17.
//  Copyright © 2017 Janis Villarroel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    @IBAction func signIn(_ sender: Any) {
    }
}

