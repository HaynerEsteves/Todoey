//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray: [Item] = []
    
    // use of userDefaults, 1-create object, 2-save object, 3-retrieve object
    // let defaults = UserDefaults.standard
    
    // trying to save data that is a custom data type (Item) user defafaults wont work. Trying with the FileManager.
    //1- creating filepath for saving information on the users phone
    //this is also the path for the plist(named item.plist). It will be used when necessary, but does not create the file itself. only the path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //this is how we tap into the persistentContainer inside AppDelegate to use its context
    //Normaly ut would be like AppDelegateObject.PersistentContainer.viewConttext, but UIApplication.shared.delegate as! AppDelegate is how we create this object. With a singleton
    //UIApplication is the class, shared is the singleton object, and delegate is the object's delegate.
    //then we cann use the property persist.Cont. to get the viewContext > This will be used to create an item with context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var selectedCategory : Category? {
        didSet {
            //loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //use of UderDefaults 3-retrieve object
        //if let storedItems = defaults.array(forKey: K.defaultsKey) as? [Item] {
        //    itemArray = storedItems
        //}
        
    }
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating reusablecell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //add the "for: indexPath" method for non optional return
        //for shorter code
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title //setting label on cell for String "itemArray[indexPath.row]"
        
        //Ternary Operator > It substitutes all the if else code for bool value. Instead of: if item == false {item = true} else {item = false}
        //value = condition == true ? ValueIfTrue : ValueIfFalse
        //Value = Condition ? ValueIfTrue : ValueIfFalse (Even shorter version)
        cell.accessoryType = item.checkStatus ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    //not necessary to put the delegate in place since the view is of type tableviewcontroler, that enherits from UITableViewController insted of adding a tableview to a ViewController
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])//printing the item on the array by getting the row of the selected cell
        tableView.deselectRow(at: indexPath, animated: true)//making it stop beeing grey after selection. better behavior
        
        //since the line below is a bool, we can change the if item == false { iten = true } else {iten = false}.
        //this line changes tha state of the checkStatus upon selectioin of cell on the tableview.
        itemArray[indexPath.row].checkStatus = !itemArray[indexPath.row].checkStatus
        
        //to delete from the core data just specify the array position to delete it
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Itens
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        //to take out the value inside the closure of the alert.textfield, make a new object UTEctField() global for this IBAction.
        var textField = UITextField()
        
        //create alert to later implement text filed on the alert
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // add textfield to the alert
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            //using the textfield object created for this action to use it outside the closure
            textField = alertTextField
        }
        
        //create alert button for action inside the alert "add item". is the button name. to be later added to the alert
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            //creating item using plist storage method. method File manager
            //let newItem = Item(Description: textField.text ?? "Error adding item")
            
/*
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.checkStatus = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            // use of defaults 2-save object, 3-retrieve object
            //self.defaults.set(self.itemArray, forKey: K.defaultsKey)
            
            self.saveItems()
*/
            self.tableView.reloadData()
        }
        
        //adding the button to the alert
        alert.addAction(action)
        
        //presenting the textfield to the user
        present(alert, animated: true)
        //self.tableView.reloadData()
    }
    
    
    //MARK: - Model Manipulation Methods
    
    //function to encode and create/write the plist file
    func saveItems() {
        
        // 2- To save itens with custom classes (Item), user defaluts wont work. Use File Manager
        // after creating the URL where tha plist file will be saved. we need to encode the data, then write it (create the file)
        // Creating data Encoder
        //let encoder = PropertyListEncoder()
        
        do {
            //encoding item array data so it can be written. Encode needs a Try, that needs a do-catch block
            //let data = try encoder.encode(itemArray)
            //try data.write(to: dataFilePath!)
            
            //saving data on the context to the database
            try context.save()
            
        } catch {
            print("Error saving data: \(error)")
        }
    }
/*
    //in this func is provided a default value in case request is not provided
    func loadItems(with predicate: NSPredicate? = nil) {
        //1- fetch the data inside the coreData
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory == %@", selectedCategory!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "checkStatus", ascending: true)]
        
        do{
            itemArray = try context.fetch(request)//method to load the data from the Coredata.
        }catch {
            print("error on loading data \(error)")
        }
        tableView.reloadData()
    }
*/
}

//MARK: - SearchBar Methods
/*
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ////let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //adding predicate to the request (Filter)
        //"name CONTAINS[cd] %@" is a format string for coredata use
        let searchPredicate = NSPredicate(format: "\(K.titleAttribute) CONTAINS[cd] %@", searchBar.text!)
        
        //Adding sort to the result. sortDescriptions expect an array of sorting [age, price, gender] in this case its only 1 item on the array the NSSort...
        ////request.sortDescriptors = [NSSortDescriptor(key: "\(K.titleAttribute)", ascending: true)]
        
        loadItems(with: searchPredicate)
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
*/
