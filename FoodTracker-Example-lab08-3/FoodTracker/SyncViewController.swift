//
//  SyncViewController.swift
//  FoodTracker
//
//  Created by jbian on 11/18/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import UserNotifications
class SyncViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var realm:Realm?
    
    let imagePicker = UIImagePickerController()
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
     let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
       
        //syncCloudToLocalDB()
        /*
        // GET
        Alamofire.request("https://ios-course-5279a.firebaseio.com/user.json", method: .get).responseJSON { response in
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
                print("the data is \(json["-KzG-ecZgoksJNxiO7C2"]["ci"])")
                
                for (key,subJson):(String, JSON) in json {
                    // Do something you want
                    print("the key is ---> \(key) the value is \(subJson)")
                }
            }
            
           
            
            
        }
        
        
        // POST
        let parameters: Parameters = [
            "ci": 66666,
            "userName": "JHONNY VILLARROEL"
        ]
        /*
         {
         "ci": 64444334,
         "userName": "jhonnjjjsy"
         }
         */

        Alamofire.request("https://ios-course-5279a.firebaseio.com/user.json", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        
        // DELETE
        Alamofire.request("https://ios-course-5279a.firebaseio.com/user/-KyhBjRdH6MBRORHY7ic.json", method: .delete)
        // UPDATE or PATCH
        let paramsUpdate:Parameters = [
            "ci": 8888888
        ]
        Alamofire.request("https://ios-course-5279a.firebaseio.com/user/-KzFqQfy64S3WHEuw6pD.json", method: .patch,parameters:paramsUpdate, encoding: JSONEncoding.default)
        */

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func syncCloudToLocalDB (){
        print("Sync cloud to Local DB...");
        Alamofire.request("https://ios-course-5279a.firebaseio.com/meal.json", method: .get).responseJSON { response in
            if let data = response.data, let _ = String(data: data, encoding: .utf8) {
                let cloudData = try! JSON(data: data)
                
                
                    for (key,subJson):(String, JSON) in cloudData {
                        // Do something you want
                        print("the key is ---> \(key) the value is \(subJson["name"])")
                        // populate attr Meal
                        let photo:NSData = NSData(base64Encoded: subJson["photo"].stringValue, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                        let raiting = subJson["raiting"].intValue
                        let name = subJson["name"].stringValue
                        let id = subJson["id"].stringValue
                        let cloudId = key
                        
                        let selectedMeal =
                            self.realm?.objects(MealDB.self)
                                .filter("id == %@",
                                        id).first
                        
                        // Review if Meal is in the cloud
                        if selectedMeal != nil  {
                            // update
                            
                            try! self.realm?.write {
                                // add Cloud ID to new element
                                selectedMeal?.cloudId = key
                            }
                            continue
                            
                        } else {
                            // Insert
                        print("the meal selected is \(selectedMeal)")
                        // create DB object
                        let newMealDB = MealDB()
                        // Copy from Object To ObjectDB
                        newMealDB.id = id
                        newMealDB.name = name
                        newMealDB.raiting = raiting
                        // Convert Image to NSDATA
                        newMealDB.photo =  photo
                        newMealDB.cloudId = cloudId
                        // Save new meal into DB
                        try! self.realm?.write {
                            
                            print("Save !!! --Paht --> \( Realm.Configuration.defaultConfiguration.fileURL)")
                            self.realm?.add(newMealDB)
                            
                        }
                           
                    }
                  
                }
                // Finish all process and start sync table view controller
                let navc = self.tabBarController?.viewControllers![0] as! UINavigationController
                let vc = navc.topViewController as! FoodTableViewController
                vc.reloadAllTable()
                self.stopActivityIndicator()
                
                
            }
        }
        
    }
    
    
    func syncLocalDBToCloud () {
        print("SYnc Local DB to Cloud");
        let mealObjsDB = self.realm?.objects(MealDB.self)
        for mealDBSelected in mealObjsDB!{
            // POST new Data
            if(mealDBSelected.cloudId == ""){
                let base64Data = mealDBSelected.photo?.base64EncodedString(options: .lineLength76Characters)
                let parameters:Parameters = [
                    "id": mealDBSelected.id!,
                    "name": mealDBSelected.name!,
                    "photo":base64Data!,
                    "raiting":mealDBSelected.raiting
                ]
               
                
                Alamofire.request("https://ios-course-5279a.firebaseio.com/meal.json", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                continue
            }
            // DELETE Data in cloud
            if mealDBSelected.isDeleted == true {
                if(mealDBSelected.cloudId != ""){
                        Alamofire.request("https://ios-course-5279a.firebaseio.com/meal/\(mealDBSelected.cloudId).json", method: .delete)
                    continue
                }
                
            }
            // UPDATE Data in the cloud
            if mealDBSelected.isUpdated == true {
                if(mealDBSelected.cloudId != ""){
                   
                    let base64Data = mealDBSelected.photo?.base64EncodedString(options: .lineLength64Characters)
                    //print("the photo is --->\(base64Data)")
                    let paramsUpdate:Parameters = [
                    "name": mealDBSelected.name,
                    "photo":base64Data,
                    "raiting":mealDBSelected.raiting
                    ]
                    Alamofire.request("https://ios-course-5279a.firebaseio.com/meal/\(mealDBSelected.cloudId).json", method: .patch,parameters:paramsUpdate, encoding: JSONEncoding.default)
                    continue
                }
            }
        }
    }

    @IBAction func startSync(_ sender: UIButton) {
       self.activityIndicator("Syncing with Cloud..")
       self.syncCloudToLocalDB()
       self.syncLocalDBToCloud()
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    func stopActivityIndicator(){
        self.effectView.removeFromSuperview()
    }
    func showNotification(message: String){
        let content = UNMutableNotificationContent()
        content.title = "Sync Message"
        content.body = message
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                        repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
            
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        center.add(request, withCompletionHandler: nil)
        
    }
   

}
