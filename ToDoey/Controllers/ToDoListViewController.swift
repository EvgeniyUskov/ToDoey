//
//  ViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 08/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    //MARK: Constants
    let SEARCH_BY_TITLE_QUERY = "title CONTAINS[cd] %@"
    let SEARCH_BY_CATEGORY_QUERY = "parentCategory.title MATCHES  %@"// LIKE was MATCHES
    
    //MARK: variables
    let realm = try! Realm()
    
    var todoItems: Results<Item>? //AUTO_UPDATING container
    var selectedCategory: Category? {
        // as soon as selectedCategory is set this Code will run
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory , in: .userDomainMask ))
//        loadData()//  can call like that beacuse we have a default value for the parameter
     }

    // MARK: TableView DataSource methods
    // when load up cells
    // triggers when reloadData() is called
    // runs for every row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueue reusable cell !impotant for the memory of the phone
        let cell = tableView.dequeueReusableCell(withIdentifier:   "ToDoItemCell", for: indexPath)
        // create new cell from the data of the item
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked == true ? .checkmark :  .none
        }
        else {
            cell.textLabel?.text = "No items added yet"
            if todoItems == nil {
                cell.textLabel?.textColor = UIColor.gray
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // MARK: TableView  Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write{
                    item.checked = !item.checked
//                    realm.delete(item)
                }
            } catch {
               print("error updating item checked status, \(error)")
            }
        }
        
          tableView.reloadData() // runs cellForRow() internally
        tableView.deselectRow(at: indexPath, animated: true)// remove selection form row
    }

    // MARK: Add new  item method
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item ()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("error saving item\(error)")
                }
             }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        // show alert
        present(alert , animated: true, completion: nil)
        
    }
    
    // MARK: Data Model manipulation methods
 
    func loadData() {
        // auto updating list
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
}

// MARK: - SearchBar Delegate
extension ToDoListViewController: UISearchBarDelegate {
    // MARK: SearchBar methods
    // triggers when Search button on keyboard is tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            todoItems = todoItems?.filter( SEARCH_BY_TITLE_QUERY, text )
                .sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
    
    // Method called wen text is changed and also when cancel button tapped
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadData()
            tableView.reloadData()
            DispatchQueue.main.async {
                // move focus from searchBar
                searchBar.resignFirstResponder()
            }
         }
    }
}
