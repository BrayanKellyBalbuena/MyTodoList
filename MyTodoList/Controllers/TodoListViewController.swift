//
//  ViewController.swift
//  MyTodoList
//
//  Created by Brayan Kelly Balbuena on 1/6/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var toDoItems = [Item]()
    let defaults = UserDefaults.standard
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
       loadItems()
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].title
        
        let item = toDoItems[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    
   // MARK - TableView Delegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      toDoItems[indexPath.row].isDone = !toDoItems[indexPath.row].isDone
    
        saveItems()
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK -
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.toDoItems.append(Item(title: textField.text!))
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(toDoItems)
            try data.write(to: dataFilePath!)
        } catch {
            print("Erro encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                toDoItems = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array")
            }
            
        }
    }
}

