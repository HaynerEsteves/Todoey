//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating reusablecell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //for shorter code
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title //setting label on cell for String "itemArray[indexPath.row]"
            
            //Ternary Operator > It substitutes all the if else code for bool value. Instead of: if item == false {item = true} else {item = false}
            //value = condition == true ? ValueIfTrue : ValueIfFalse
            //Value = Condition ? ValueIfTrue : ValueIfFalse (Even shorter version)
            cell.accessoryType = item.checkStatus ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    //not necessary to put the delegate in place since the view is of type tableviewcontroler, that enherits from UITableViewController insted of adding a tableview to a ViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //se não tiver nulo, execute a troca do statusCheck
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //since the line below is a bool, we can change the if item == false { iten = true } else {iten = false}.
                    item.checkStatus = !item.checkStatus
                    //realm.delete(item)
                }
            }catch {
                print("erro updating checkstatus on realm \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)//making it stop beeing grey after selection. better behavior
    }
    
    //MARK: - Add New Itens
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        //to take out the value inside the closure of the alert.textfield, make a new object UITextField() global for this IBAction.
        var textField = UITextField()
        
        //create alert to later implement text field on the alert
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // add textfield to the alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            //using the textfield object created for this action to use it outside the closure
            textField = alertTextField
        }
        
        //create alert button for action inside the alert "add item". is the button name. to be later added to the alert
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            //aqui nesse caso, quando recebemos o item category da CategoryVC, esse item ja tem uma lista pra receber todos os itens. vc tem q adicionar itens nessa lista.
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        //as modificações sempre devem ser feitas dentro do realm.write{}
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.item.append(newItem)
                    }
                } catch {
                    print("erro saving data on realm TDLVC: \(error)")
                }
                self.tableView.reloadData()
            }
        }
        
        //adding the button to the alert
        alert.addAction(action)
        
        //presenting the textfield to the user
        present(alert, animated: true)
    }
    
    //MARK: - Data Manipulation
    
    func loadItems() {
        //a função load deve passar os itens para o todoItems. cada category tem uma lista de itens dentro q pode ser visualzada e dada append. aqui é como é visualizada
        //sorted é uma caracteristica de List de realm
        todoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {

        if let itemForDeletion = selectedCategory?.item[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("erro deleting item \(error)")
            }
        }

    }
    
}

//MARK: - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?
            .filter("title CONTAINS [cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: false)
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

