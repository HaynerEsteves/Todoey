//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
class TodoListViewController: UITableViewController {

    let itemArray: [String] = ["buy eggs", "fazer as coisas do pai", "Estudar Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
