//
//  ViewController.swift
//  SPELLS
//
//  Created by D Spafford on 02/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import RealmSwift

class SpellingItemsViewController: SwipeTableViewController {

    var spellingItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedTopic : Topic? {
        
        didSet {
            
            loadItems()
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spellingItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = spellingItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //set up Ternary operator to replace if and else
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
            
            }
        
      return cell
        
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = spellingItems?[indexPath.row] {
            
            do {
            
            try realm.write {
                
                item.done = !item.done
                
            }
                
            } catch {
                
                print("Error saving done status, \(error)")
                
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Spelling Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentTopic = self.selectedTopic {
              
                do {
                    
                    try self.realm.write {
                    
                    let newItem = Item()
                    
                    newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                    
                    currentTopic.items.append(newItem)
                    
                    }
                    
                } catch {
                    
                  print("Error saving new items, \(error)")
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        }
       
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
     spellingItems = selectedTopic?.items.sorted(byKeyPath: "title", ascending: true)
        
       tableView.reloadData()
  }
    
    //MARK:- Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let spellingItemForDeletion = self.spellingItems?[indexPath.row] {
        
        do {
            
            try self.realm.write {
                
                self.realm.delete(spellingItemForDeletion)
                
            }
            
        } catch {
            
            print("Error deleting spelling item \(error)")
        }
    }
    
    }
}
//MARK:- Search bar methods

extension SpellingItemsViewController: UISearchBarDelegate {
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    spellingItems = spellingItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
    
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












