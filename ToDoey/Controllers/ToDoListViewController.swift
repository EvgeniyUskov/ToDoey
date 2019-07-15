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
    
//    var itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorogn"]
    var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray.append(contentsOf:[
            Item(text: "Find Mike", checked: false),
            Item(text: "Buy eggos", checked: false),
            Item(text: "Destroy Demogorogn", checked: false)
        ])
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
     }

    // MARK: TableView DataSource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:   "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].text
        if itemArray[indexPath.row].checked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView  Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add item methods
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // ?? "value" if it's nil we gonna set default value
            if let newText = textField.text {
                let newItem = Item(text: newText, checked: false)
                self.itemArray.append(newItem)
//                self.itemArray.append(Item(text: text, checked: false))
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

