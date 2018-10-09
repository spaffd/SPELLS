//
//  TopicViewController.swift
//  SPELLS
//
//  Created by D Spafford on 08/10/2018.
//  Copyright © 2018 D Spafford. All rights reserved.
//

import UIKit
import CoreData

class TopicViewController: UITableViewController {
    
    var topics = [Topic]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

     loadTopics()
        
    }

    //MARK:- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        
        let topic = topics[indexPath.row]
        
        cell.textLabel?.text = topic.name
        
        return cell
    
    }
    
    //MARK:- TableView Delegate Methods
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! SpellingItemsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedTopic = topics[indexPath.row]
            
        }
        
    }
    
    
    //:- Data Manipulation Methods
    
   func saveTopics() {
        
        do{
            
           try context.save()
            
       } catch {
    
           print("Error saving context \(error)")
            
    }
        
tableView.reloadData()
        
}
    
  func loadTopics() {
    
    let request : NSFetchRequest<Topic> = Topic.fetchRequest()
        
    do{
            
          topics = try context.fetch(request)
            
      } catch {
            
        print("Error fetching data from context \(error)")
            
       }
        
       tableView.reloadData()
        
   }
    
    //MARK:- Add New Topics
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Topic", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTopic = Topic(context: self.context)
        
        newTopic.name = textField.text!
        
        self.topics.append(newTopic)
            
            self.saveTopics()
        
        }
        
        alert.addAction(action)
        
        alert.addTextField {(field) in
        
          textField = field
            
            textField.placeholder = "Add a new topic"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
  
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
