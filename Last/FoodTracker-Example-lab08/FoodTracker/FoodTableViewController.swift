//
//  FoodTableViewController.swift
//  FoodTracker
//
//  Created by jbian on 11/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import RealmSwift

class FoodTableViewController: UITableViewController {
    var meals = [Meal]()
    var realm:Realm?
    override func viewDidLoad() {
        super.viewDidLoad()
        // add hardcoded Meals
        realm = try! Realm()
      /*  let silpancho = Meal(id:NSUUID().uuidString,name: "silpancho", photo:UIImage(named:"silpancho") , raiting: 0,city:"CBBA")
        let pique = Meal(id:NSUUID().uuidString,name: "pique", photo:UIImage(named:"pique") , raiting: 4, city:"CBBA")
        meals.append(silpancho!)
        meals.append(pique!)*/
        let arrayMeal = realm?.objects(MealDB.self)
        //iterate
        for mealDB in arrayMeal!{
            let photo = UIImage(data:mealDB.photo! as Data)
            var newMeal = Meal(id:mealDB.id!,name:mealDB.name!,photo:photo,raiting:mealDB.raiting,city:mealDB.city!)
            meals.append(newMeal!)
        }
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func saveMeal(meal: Meal){
        
        let newMealDb = MealDB()
        newMealDb.id = meal.id
        newMealDb.name = meal.name
        newMealDb.city = meal.city
        newMealDb.raiting = meal.raiting
        

        // convert image to
        //let data = UIImagePNGRepresentation() as NSData?
        newMealDb.photo =  UIImagePNGRepresentation(meal.photo!)! as NSData
        
        print ("the uuid --> \(UIDevice.current.identifierForVendor)")
        try! self.realm?.write {
            
            print("Save !!! --Paht --> \( Realm.Configuration.defaultConfiguration.fileURL)")
            self.realm?.add(newMealDb)
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
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! FoodTableViewCell
        // get Model meal
        let meal = meals[indexPath.row]
        cell.photoMeal.image = meal.photo
        cell.raiting.rating = meal.raiting
        cell.mealLabel.text = meal.name
        cell.cityLabel.text = meal.city
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let mealToRemove = meals[indexPath.row]
            let dbObjToRemove = realm?.objects(MealDB.self).filter("id==%@",mealToRemove.id!).first
            try! realm?.write {
                realm?.delete(dbObjToRemove!)
                meals.remove(at: indexPath.row)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    
    
    @IBAction func unwindToMealList(send: UIStoryboardSegue){
        
        print("Unwiped!!!!!")
        if let sourceViewController = send.source as? ViewController, let meal = sourceViewController.meal{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // update meal
                meals[selectedIndexPath.row] = meal
                let mealToUpdate = realm?.objects(MealDB.self).filter("id==%@",meal.id).first
                try! realm?.write {
                    mealToUpdate?.name = meal.name
                    mealToUpdate?.city = meal.city
                    mealToUpdate?.raiting = meal.raiting
                    mealToUpdate?.photo = UIImagePNGRepresentation(meal.photo!) as! NSData
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
                
            }else{
                // new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                saveMeal(meal: meal)
                print("the meal name is \(meal.name) ")
                //tableView.reloadData() Recarga la vista
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
 
        // todo return data
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare 1")
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            print("add Item")
            //os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            print("Show Detal")
            
            guard let mealDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? FoodTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        case "EditMeal":
            print("Edit Meal ")
            guard let mealDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? FoodTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            print("Default")
            //fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
}
