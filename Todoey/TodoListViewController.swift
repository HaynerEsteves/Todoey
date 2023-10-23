//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
class TodoListViewController: UITableViewController {

    var itemArray: [String] = ["buy eggs", "fazer as coisas do pai", "Estudar Swift"]
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            self.itemArray.append(textField.text ?? "N fez o append")
            self.tableView.reloadData()
        }
        //adding the button to the alert
        alert.addAction(action)
        
        
        
        //presenting the textfield to the user
        present(alert, animated: true)
        //self.tableView.reloadData()
    }
    
}



//MARK: - DataSource Delegate

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating reusablecell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)//add the "for: indexPath" method for non optional return > Option click on cell
        cell.textLabel?.text = itemArray[indexPath.row] //setting label on cell for String "itemArray[indexPath.row]"
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate
//not necessary to put the delegate in place since the view is of type tableviewcontroler, that enherits from UITableViewController insted of adding a tableview to a ViewController
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])//printing the item on the array by getting the row of the selected cell
        tableView.deselectRow(at: indexPath, animated: true)//making it stop beeing grey after selection. better behavior
        
        //check if the
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
}
