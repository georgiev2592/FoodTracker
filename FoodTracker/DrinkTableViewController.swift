//
//  DrinkTableViewController.swift
//  FoodTracker
//
//  Created by Petar Georgiev on 10/18/16.
//  Copyright © 2016 Petar Georgiev. All rights reserved.
//

import UIKit

class DrinkTableViewController: UITableViewController {
   
   // MARK: Properties
   var drinks = [Drink]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Use the edit button item provided by the table view controller.
      navigationItem.leftBarButtonItem = editButtonItem
      
      // Load any saved meals, otherwise load sample data.
      if let savedDrinks = loadDrinks() {
         drinks += savedDrinks
      } else {
         // Load the sample data.
         loadSampleDrinks()
      }
   }
   
   func loadSampleDrinks() {
      let photo1 = UIImage(named: "drink1")!
      let drink1 = Drink(name: "Mojito", photo: photo1, rating: 4)!
      
      let photo2 = UIImage(named: "drink2")!
      let drink2 = Drink(name: "Stella Artois", photo: photo2, rating: 5)!
      
      let photo3 = UIImage(named: "drink3")!
      let drink3 = Drink(name: "Cosmopolitan", photo: photo3, rating: 3)!
      
      drinks += [drink1, drink2, drink3]
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return drinks.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // Table view cells are reused and should be dequeued using a cell identifier.
      let cellIdentifier = "DrinkTableViewCell"
      
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DrinkTableViewCell
      
      // Fetches the appropriate meal for the data source layout.
      let drink = drinks[indexPath.row]
      
      cell.nameLabel.text = drink.name
      cell.photoImageView.image = drink.photo
      cell.ratingControl.rating = drink.rating
      
      return cell
   }
   
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      // Return false if you do not want the specified item to be editable.
      return true
   }
   
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         // Delete the row from the data source
         drinks.remove(at: indexPath.row)
         saveDrinks()
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
   
   
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "ShowDrinkDetail" {
         let drinkDetailViewController = segue.destination as! DrinkViewController
         // Get the cell that generated this segue.
         if let selectedDrinkCell = sender as? DrinkTableViewCell {
            let indexPath = tableView.indexPath(for: selectedDrinkCell)!
            let selectedDrink = drinks[indexPath.row]
            drinkDetailViewController.drink = selectedDrink
         }
      } else if segue.identifier == "AddDrinkItem" {
         print("Adding new drink.")
      }
   }
   
   
   @IBAction func unwindToDrinkList(sender: UIStoryboardSegue) {
      if let sourceViewController = sender.source as? DrinkViewController, let drink = sourceViewController.drink {
         
         if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing drink.
            drinks[selectedIndexPath.row] = drink
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
         } else {
            // Add a new drink.
            let newIndexPath = NSIndexPath(row: drinks.count, section: 0)
            
            drinks.append(drink)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
         }
         
         // Save the drinks.
         saveDrinks()
      }
   }
   
   // MARK: NSCoding
   func saveDrinks() {
      let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(drinks, toFile: Drink.ArchiveURL.path)
      
      if !isSuccessfulSave {
         print("Failed to save drinks...")
      }
   }
   
   func loadDrinks() -> [Drink]? {
      return NSKeyedUnarchiver.unarchiveObject(withFile: Drink.ArchiveURL.path) as? [Drink]
   }
}
