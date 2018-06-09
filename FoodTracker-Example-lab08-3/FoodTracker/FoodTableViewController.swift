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
        // connect to DB
        realm = try! Realm()
        
        // add hardcoded Meals
        /*
        let silpancho = Meal(id: NSUUID().uuidString ,name: "silpancho", photo:UIImage(named:"silpancho") , raiting: 0)
        let pique = Meal(id:NSUUID().uuidString, name: "pique", photo:UIImage(named:"pique") , raiting: 4)*/
        
        // retrieve from DB
        
        
       
        navigationItem.leftBarButtonItem = editButtonItem
        reloadAllTable()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        tableView.reloadData()
        
    }
    func loadData(){
       
        let arrayMeal = realm?.objects(MealDB.self)
        meals.removeAll()
        for mealDB in arrayMeal!{
            if mealDB.isDeleted == true{
                continue
            }
            let photo = UIImage(data: mealDB.photo! as Data)
            let newMeal = Meal(id: mealDB.id!,
                               name: mealDB.name!,
                               photo: photo,
                               raiting: mealDB.raiting)
            
            meals.append(newMeal!)
        }
        
        tableView.reloadData()
    }
    
    func saveMeal(meal: Meal){
        // create DB object
        let newMealDB = MealDB()
        // Copy from Object To ObjectDB
        newMealDB.id = meal.id
        newMealDB.name = meal.name
        newMealDB.raiting = meal.raiting
        // Convert Image to NSDATA
        newMealDB.photo =  UIImagePNGRepresentation(meal.photo!)! as NSData
        // Save new meal into DB
        try! self.realm?.write {
            
            print("Save !!! --Paht --> \( Realm.Configuration.defaultConfiguration.fileURL)")
            self.realm?.add(newMealDB)
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
            let selectedMeal = meals[indexPath.row]
            let mealToDelete =
                realm?.objects(MealDB.self)
                    .filter("id == %@",
                            selectedMeal.id).first
            try! realm?.write {
                //realm?.delete(mealToDelete!)
                mealToDelete?.isDeleted = true
            }
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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
    
    // TableViewController // sent dato to back
    @IBAction func unwindToMealList(send: UIStoryboardSegue){
        
        print("Unwiped!!!!!")
        
        if let sourceViewController = send.source as? ViewController, let meal = sourceViewController.meal{
            /*
            meals.append(meal);
            tableView.reloadData()*/
            
            // click in row
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                // update meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
                // update Data
                let mealToUpdate =
                    realm?.objects(MealDB.self)
                        .filter("id == %@",
                                meal.id).first
                try! realm?.write {
                    mealToUpdate?.name = meal.name
                    mealToUpdate?.raiting = meal.raiting
                    mealToUpdate?.photo =
                    UIImagePNGRepresentation(meal.photo!) as! NSData
                    mealToUpdate?.isUpdated = true
                }
                
                // click + button
            }else{
                // new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                // save new Meal
                saveMeal(meal: meal)
                
                print("the meal name is \(meal.name) ")
                //tableView.reloadData()
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
 
        // todo return data
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
            
        default:
            print("Default")
            //fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    func reloadAllTable(){
        print("Reload Table!!!!!!!!!!!")
        self.loadData()
    }
}
