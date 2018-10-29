//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Lawless on 10/28/18.
//  Copyright © 2018 Peter Lawless. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Break sound barrier", "Go back to school", "Take over world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Tableview Datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row  = tableView.cellForRow(at: indexPath)
        row?.accessoryType = row?.accessoryType == .checkmark ? .none : .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

