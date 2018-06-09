//
//  DogViewController.swift
//  DoguiApp
//
//  Created by Janis on 12/11/17.
//  Copyright © 2017 Janis Villarroel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DogViewController: UIViewController {

    @IBOutlet weak var breerTitle: UILabel!
    
    @IBOutlet weak var imageDogFinal: UIImageView!


    var dog:Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text=dog?.breed
        breerTitle.text="Raza Seleccionada: "+text!
        // Do any additional setup after loading the view.
        let path="https://dog.ceo/api/breed/"+text!+"/images/random"
        print(path)
        Alamofire.request(path, method: .get).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                let json = try! JSON(data: data)
                print("the length \(json.count)")
                //print("the data is \(json["-KzG-ecZgoksJNxiO7C2"]["ci"])")
                for (key,subJson):(String, JSON) in json {
                    // Do something you want
                    if key == "message" {
                        print("the key is ---> \(key) the value is \(subJson)")
                        let theURL = URL(string:"\(subJson)")
                        let imagedData = NSData(contentsOf: theURL!)!
                        let theImage = UIImage(data: imagedData as Data)
                        self.imageDogFinal.image = theImage
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
