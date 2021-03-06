//
//  TopicViewController.swift
//  SPELLS
//
//  Created by D Spafford on 08/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TopicViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var topics: Results<Topic>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

     loadTopics()
        
        tableView.separatorStyle = .none
        
    }

    //MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return topics?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
        if let topic = topics?[indexPath.row] {
        
        //cell.textLabel?.text = topics?[indexPath.row].name ?? "No Topics Added Yet"
            
            cell.textLabel?.text = topic.name
            
            guard let topicColour = UIColor(hexString: topic.colour) else {fatalError() }
            
           // cell.backgroundColor = UIColor(hexString: topics?[indexPath.row].colour ?? "FF3261")
                
                cell.backgroundColor = topicColour
        
            cell.textLabel?.textColor = ContrastColorOf(topicColour, returnFlat: true)
        
    }
        
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
    
    //MARK:- Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
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
    
    //MARK:- Add New Topics
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Topic", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTopic = Topic()
        
        newTopic.name = textField.text!
            
            newTopic.colour = UIColor.randomFlat.hexValue()
            
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
    
  
    
  
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    

