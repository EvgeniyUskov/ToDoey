//
//  ViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 08/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    //MARK: Constants
    let SEARCH_BY_TITLE_QUERY = "title CONTAINS[cd] %@"
    let SEARCH_BY_CATEGORY_QUERY = "parentCategory.title MATCHES  %@"// LIKE was MATCHES
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    //MARK: variables
    var itemArray = [Item]()
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.checked == true ? .checkmark :  .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView  Delegate methods
    // click on cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveData()
        tableView.reloadData() // runs cellForRow() internally
        tableView.deselectRow(at: indexPath, animated: true)// remove selection form row
    }

    // MARK: Add item methods
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // alert window
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        // action for the alert
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let newText = textField.text { // if something typed in textField
                let item = Item(context: self.context) // create new item
                item.parentCategory = self.selectedCategory // set fileds for the item
                item.title = newText
                item.checked = false
                self.itemArray.append(item)// add new item to the array
            }
            self.saveData() // connection through the constructor with the context?
            self.tableView.reloadData()
        }
        // add textField to alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        // add action to alert
        alert.addAction(action)
        // show alert
        present(alert , animated: true, completion: nil)
        
    }
    
    // MARK: Data Model manipulation methods
    func saveData() {
        do{
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
    }

    // Method with default values for the parameters  if undefined
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(),
                    predicate: NSPredicate? = nil ) {
        // "parentCategory.title MATCHES %@"
        let categoryPredicate = NSPredicate(format:  SEARCH_BY_CATEGORY_QUERY, selectedCategory!.title!) // always search by category
        if let additionalPredicate = predicate { // if predicate not nil , do and add COMPOUND predicate
             let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else { // add ONLY CATEGORY predicate
            request.predicate = categoryPredicate
        }
        
        do{
            // fetch request
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context\(error)")
        }
    }
    
    func deleteData() {
        if let indexPath = tableView.indexPathForSelectedRow {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            
            saveData()
            tableView.reloadData()
        }
    }
    
}

// MARK: - SearchBar Delegate
extension ToDoListViewController: UISearchBarDelegate {
    // MARK: SearchBar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //"title CONTAINS[cd] %@"
        let predicate = NSPredicate(format:  SEARCH_BY_TITLE_QUERY, searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, predicate: predicate)
        tableView.reloadData()
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
