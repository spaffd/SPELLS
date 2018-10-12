//
//  TopicViewController.swift
//  SPELLS
//
//  Created by D Spafford on 08/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import RealmSwift

class TopicViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var topics: Results<Topic>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

     loadTopics()
        
    }

    //MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topics?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        
        cell.textLabel?.text = topics?[indexPath.row].name ?? "No Topics Added Yet"
        
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
