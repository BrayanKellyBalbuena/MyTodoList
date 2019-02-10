//
//  CategoryTableViewController.swift
//  MyTodoList
//
//  Created by Brayan Kelly Balbuena on 1/18/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        loadItems()
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            if let category = categories?[indexPath.row] {
                cell.textLabel?.text = category.name
                let currentColor = UIColor(hexString: category.hexcolor)
                cell.backgroundColor = currentColor
                cell.textLabel?.textColor = ContrastColorOf(currentColor!, returnFlat: true)
                
            } else {
                 cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categoris added yet"
            }
            
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: Perfoms Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error trying to save \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
                let category = Category()
                category.name = textField.text!
                category.hexcolor = UIColor.randomFlat.hexValue()
                self.saveCategories(category: category)
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
     override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDelete);
                }
            } catch {
                print("\(error)")
            }
            
            tableView.reloadData()
        }
    }
}

 //MARK: SearchBar Delegates

extension CategoryTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "name", ascending: false)
        
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
