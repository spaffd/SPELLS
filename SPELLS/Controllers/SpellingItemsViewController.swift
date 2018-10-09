//
//  ViewController.swift
//  SPELLS
//
//  Created by D Spafford on 02/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import CoreData

class SpellingItemsViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedTopic : Topic? {
        
        didSet {
            
            loadItems()
            
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
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
        
     //context.delete(itemArray[indexPath.row])
        
      //  itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Spelling Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentTopic = self.selectedTopic
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
       
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do{
         
        try context.save()
            
        
        } catch {
            
    print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
       let topicPredicate = NSPredicate(format: "parentTopic.name MATCHES[cd] %@", selectedTopic!.name!)
        
        if let additionalPredicate = predicate {
            
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [topicPredicate, additionalPredicate])
            
        } else {
            
           request.predicate = topicPredicate
            
        }
        
        do {
        
      itemArray = try context.fetch(request)
            
        } catch {
            
         print("Error fetching data from context \(error)")
            
        }
        
        tableView.reloadData()
   }
    
}
//MARK:- Search bar methods

extension SpellingItemsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
         loadItems()
            
            DispatchQueue.main.async {
             
                searchBar.resignFirstResponder()
                
            }
            
            
            
        }
    }
    
    
}











