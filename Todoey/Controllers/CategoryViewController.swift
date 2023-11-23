//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hayner Esteves on 07/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var category: Results<Category>?//since its a auto updated container it does not neet to be appended. it will listen for changes
    
    let realm = try! Realm()//try! is only possible because realm can only fail in the first run. Its in Realm Documentation. But seems like code smell. Creating realm object
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories Added Yet"
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
/*
        do {
            category = try context.fetch(request)
        } catch {
            print("error loadign data from DataModel: \(error)")
        }
        tableView.reloadData()
*/
    }
}

//MARK: - SearchBar Methods
/*
extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategories(with: request)
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
*/
