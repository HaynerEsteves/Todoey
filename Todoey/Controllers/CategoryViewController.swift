//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hayner Esteves on 07/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    var category: Results<Category>?//since its a auto updated container it does not neet to be appended. it will listen for changes
    
    let realm = try! Realm()//try! is only possible because realm can only fail in the first run. Its in Realm Documentation. But seems like code smell. Creating realm object
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 70
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories Added Yet"
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    //MARK: - AddCategory
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new category here"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(with: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Data Manipulation
    
    func saveCategories(with category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category on DataModel\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        category = realm.objects(Category.self)
        tableView.reloadData()
    }
}

//MARK: - SearchBar Methods

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        category = category?
            .filter("name CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategories()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


//MARK: - Swipe Cell Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let safeCategoryForDeletion = self.category {
                do{
                    try self.realm.write {
                        self.realm.delete(safeCategoryForDeletion[indexPath.row])
                    }
                }catch {
                    print("erro deleting category: \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
}
