//
//  ViewController.swift
//  SPELLS
//
//  Created by D Spafford on 02/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit

class SpellingItemsViewController: UITableViewController {

    var itemArray = [Item]()
    
   let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let newItem1 = Item()
        
        newItem1.title = "light"
        
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        
        newItem2.title = "floor"
        
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        
        newItem3.title = "key"
        
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        
        newItem4.title = "free"
        
        itemArray.append(newItem4)
        
        let newItem5 = Item()
        
        newItem5.title = "large"
        
        itemArray.append(newItem5)
        
        if let items = defaults.array(forKey: "SpellingListArray") as? [Item] {
            
         itemArray = items
            
       }
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellingItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //set up Ternary operator to replace if and else
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Spelling Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            
         let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "SpellingListArray")
            
            self.tableView.reloadData()
            
        }
       
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

