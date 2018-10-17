//
//  TopicViewController.swift
//  SPELLS
//
//  Created by D Spafford on 08/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TopicViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var topics: Results<Topic>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

     loadTopics()
        
        tableView.rowHeight = 80.0
        
    }

    //MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topics?.count ?? 1
        
    }
    
    // override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    
    // cell.delegate = self
    
    // return cell
    
    // }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = topics?[indexPath.row].name ?? "No Topics Added Yet"
        
        cell.delegate = self
        
        return cell
    
    }
    
    //MARK:- TableView Delegate Methods
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! SpellingItemsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedTopic = topics?[indexPath.row]
            
        }
        
    }
    
    
    //:- Data Manipulation Methods
    
    func save(topic: Topic) {
        
        do{
            
            try realm.write {
                
                realm.add(topic)
            
       }
        }     catch {
    
           print("Error saving topic \(error)")
            
    }
        
tableView.reloadData()
        
}
    
  func loadTopics() {
    
   topics = realm.objects(Topic.self)
    
     tableView.reloadData()
        
   }
    
    //MARK:- Add New Topics
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Topic", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTopic = Topic()
        
        newTopic.name = textField.text!
            
            self.save(topic: newTopic)
        
        }
        
        alert.addAction(action)
        
        alert.addTextField {(field) in
        
          textField = field
            
            textField.placeholder = "Add a new topic"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
    
    //MARK: - Swipe Cell Delegate Methods
    
    extension TopicViewController: SwipeTableViewCellDelegate {
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
        // handle action by updating model with deletion
                
                if let topicForDeletion = self.topics?[indexPath.row] {
                    
                    do {
                        
                        try self.realm.write {
                            
                            self.realm.delete(topicForDeletion)
                            
                        }
                        
                    } catch {
                        
                        print("Error deleting topic, \(error)")
                        
                    }
                
                }
                
                
            }
            
            // customize the action appearance
            
            deleteAction.image = UIImage(named: "delete-icon")
            
            return [deleteAction]
            
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            
            var options = SwipeTableOptions()
            
            options.expansionStyle = .destructive
            
            return options
            
        }
        
    }
    
  
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    

