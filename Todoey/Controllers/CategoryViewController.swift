//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hayner Esteves on 07/11/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var category: Results<Category>?//since its a auto updated container it does not neet to be appended. it will listen for changes
    
    let realm = try! Realm()//try! is only possible because realm can only fail in the first run. Its in Realm Documentation. But seems like code smell. Creating realm object
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Erro setting color to navigation bar")}
        navBar.backgroundColor = .systemBrown
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let safeCategory = category?[indexPath.row] {
            cell.textLabel?.text = safeCategory.name
            
            let color = UIColor(hexString: safeCategory.hexCategoryColor)
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color ?? .black, returnFlat: true)
            
        } else {
            print("erro loading cells in tableVielCellForRowAt")
            cell.textLabel?.text = "error cell"
        }
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
            newCategory.hexCategoryColor = UIColor(randomFlatColorOf:.light).hexValue()
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
 
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = category?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("error eleting data \(error)")
            }
        }
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
