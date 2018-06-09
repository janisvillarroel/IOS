//
//  DogTableViewController.swift
//  DoguiApp
//
//  Created by Janis on 12/11/17.
//  Copyright © 2017 Janis Villarroel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DogTableViewController: UITableViewController {
    var dogs = [Dog]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request("https://dog.ceo/api/breeds/list/all", method: .get).responseJSON { response in
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
                var dog: Dog?
                for (key,subJson):(String, JSON) in json {
                    // Do something you want
                    print("the key is ---> \(key) the value is \(subJson)")
                    for (key1,subJson2):(String, JSON) in subJson {
                        print("the key is ---> \(key1)")
                        dog = Dog(breed:key1)
                        self.dogs.append(dog!)
                    }
                }
                
            }
            self.tableView.reloadData()
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! DogTableViewCell
        // get Model meal
        let dog = dogs[indexPath.row]
        cell.dogBreed.text=dog.breed
        // Configure the cell...
        return cell
    }    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if segue.identifier != "backPrincipal" {
            print("Show Detal")
            guard let dogViewController = segue.destination as? DogViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDogCell = sender as? DogTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDogCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDog = dogs[indexPath.row]
            dogViewController.dog = selectedDog
            print("---------\(selectedDog)")
        }
    }

    @IBAction func back(_ sender: Any) {
        print("click!!dismiss")
    }
}
