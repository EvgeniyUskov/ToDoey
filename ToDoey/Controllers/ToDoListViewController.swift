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
    // when load up cells
    // triggers when reloadData() is called
    // runs for every row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowindexPath Called")
        let cell = tableView.dequeueReusableCell(withIdentifier:   "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.text
        cell.accessoryType = item .checked == true ? .checkmark :  .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView  Delegate methods
    // when select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        tableView.reloadData()// runs cellForRow() internally
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add item methods
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
             if let newText = textField.text {
                self.itemArray.append(Item(text: newText, checked: false))
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

