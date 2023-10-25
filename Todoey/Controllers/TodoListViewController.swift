//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
class TodoListViewController: UITableViewController {
    //fazer uma classe nova, com o item adicionado e o status de marcação. Ao fazer o apend, criaremos um item dessa classe e daremos o append no array inicial (atualmente [String] futuramente [novaClasse]. pra usar o check-unckeck no delegate usar o array inicial[indexRol].ckeckStatus e ver se ta true ou false
    var itemArray: [Item] = []
    // use of defaults, 1-create object, 2-save object, 3-retrieve object
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //use of defaults 3-retrieve object
        //if let storedItems = defaults.array(forKey: K.defaultsKey) as? [Item] {
        //    itemArray = storedItems
        //}
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
        
        //create alert button for action inside the alert "add item". is the button name
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let newItem = Item(CheckStatus: false, Description: textField.text ?? "Item não adicionado")
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            self.itemArray.append(newItem)
            

            // use of defaults 2-save object, 3-retrieve object
            //self.defaults.set(self.itemArray, forKey: K.defaultsKey)
            
            self.tableView.reloadData()
        }
        
        //adding the button to the alert
        alert.addAction(action)
        
        //presenting the textfield to the user
        present(alert, animated: true)
        //self.tableView.reloadData()
    }
    
}



//MARK: - Tableview DataSource Methods

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating reusablecell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //add the "for: indexPath" method for non optional return
        //for shorter code
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.Description //setting label on cell for String "itemArray[indexPath.row]"
        
        //Ternary Operator > It substitutes all the if else code for bool value. Instead of: if item == false {item = true} else {item = false}
        //value = condition == true ? ValueIfTrue : ValueIfFalse
        //Value = Condition ? ValueIfTrue : ValueIfFalse (Even shorter version)
        cell.accessoryType = item.CheckStatus ? .checkmark : .none
        
        return cell
    }
    
}

//MARK: - TableView Delegate Methods
//not necessary to put the delegate in place since the view is of type tableviewcontroler, that enherits from UITableViewController insted of adding a tableview to a ViewController
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])//printing the item on the array by getting the row of the selected cell
        tableView.deselectRow(at: indexPath, animated: true)//making it stop beeing grey after selection. better behavior
        
        //since the line below is a bool, we can change the if item == false { iten = true } else {iten = false}.
        //this line changes tha state of the checkStatus upon selectioin of cell on the tableview.
        itemArray[indexPath.row].CheckStatus = !itemArray[indexPath.row].CheckStatus
        
        tableView.reloadData()
    }
}
