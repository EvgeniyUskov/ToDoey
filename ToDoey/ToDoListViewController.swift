//
//  ViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 08/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var defaults = UserDefaults.standard
    
    var itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorogn "]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
     }

    // MARK: TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:   "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView  Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add item methods
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // ?? "value" if it's nil we gonna set default value
            if let text = textField.text {
                self.itemArray.append(text)
            }
            // defaults saved in info.plist
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            // reload data for the UI
            self.tableView.reloadData()
        }
            // what will happen when user clicks add item button on UIAlert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            // no print() will be done only when text field will be added to UIAlert
            //  print("new item: \(String(describing: textField.text))")
        }
        alert.addAction(action)
        //preent a viewController modally
            present(alert , animated: true, completion: nil)
        
    }
}

