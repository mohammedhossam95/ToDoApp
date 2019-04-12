//
//  HomeVC.swift
//  ToDoListDemo
//
//  Created by Dev2 on 4/9/19.
//  Copyright © 2019 Hossam__95. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    var tasks = [ToDo]()
    let dateFormatter = DateFormatter()

    //MARK: Outlets
    
    @IBOutlet var taskTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Core Data Request
        
        //MARK: Register Cell Nib File
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        self.taskTable.register(nib, forCellReuseIdentifier: "TaskCell")
        
        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            tasks = try managedContext.fetch(fetchRequest) as! [ToDo]
            self.taskTable.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Functions
    
    fileprivate func setupSearchBar(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        searchBar.delegate = self
        self.taskTable.tableHeaderView = searchBar
    }
    //MARK: Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "title contains[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ToDo")
            fetchRequest.predicate = predicate
            do {
                tasks = try managedObjectContext.fetch(fetchRequest) as! [ToDo]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }else {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
            
            do {
                tasks = try managedContext.fetch(fetchRequest) as! [ToDo]
                self.taskTable.reloadData()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        self.taskTable.reloadData()
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        if task.completed == 1 {
            cell.backgroundColor = UIColor.green
        }else{
            cell.backgroundColor = UIColor.clear
        }
        cell.taskTitle.text = task.title
        cell.taskDate.text = task.date
        return cell
    }
    
    //Mark: Table View Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //TODO: Delete Rows
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let todo = self.tasks[indexPath.row]
            managedContext.delete(todo)

            do {
                try managedContext.save()
                completion(true)
            } catch {
                print("Saving Deleting object \(error.localizedDescription)")
                completion(false)
            }
        }
        
        deleteAction.image = UIImage(named: "reject")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, completion) in
            //TODO: Delete Rows
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let todo = self.tasks[indexPath.row]
            if todo.completed == 0 {
                todo.completed = 1
            }else {
             todo.completed = 0
            }
            do {
                try managedContext.save()
                self.taskTable.reloadData()
                completion(true)
            } catch {
                print("Saving Deleting object \(error.localizedDescription)")
                completion(false)
            }
        }
        editAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}
