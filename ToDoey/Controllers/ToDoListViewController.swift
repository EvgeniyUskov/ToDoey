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
//    let dataFilePath = FileManager.default.urls(for:   .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist ")
    let SEARCH_BY_TITLE_QUERY = "title CONTAINS[cd] %@"
    let SEARCH_BY_CATEGORY_QUERY = "parentCategory.title MATCHES %@"
    
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    var selectedCategory: Category? {
        // as soon as selectedCategory is set this Code will run
        didSet {
            loadDataByCategory()
        }
    }
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory , in: .userDomainMask ))
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //        loadData(with: request)
        loadData()//  can call like that beacuse we have a default value for the parameter
     }

    // MARK: TableView DataSource methods
    // when load up cells
    // triggers when reloadData() is called
    // runs for every row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:   "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.checked == true ? .checkmark :  .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: TableView  Delegate methods
    // when select cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveData()
        tableView.reloadData() // runs cellForRow() internally
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add item methods
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let newText = textField.text {
                let item = Item(context: self.context)
                item.parentCategory = self.selectedCategory 
                item.title = newText
                item.checked = false
                self.itemArray.append(item)
            }
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
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

    func loadDataByCategory(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        if let title = selectedCategory?.title {
            request.predicate = NSPredicate(format:  SEARCH_BY_CATEGORY_QUERY, title)
        }
//        loadData(with: request)
    }
    
    // method with default value for the parameter if undefined
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        let categoryPredicate = NSPredicate(format:  SEARCH_BY_CATEGORY_QUERY, selectedCategory!.title!)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate 
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context\(error)")
        }
    }
    
    func deleteData() {
//         context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row) 
        
        saveData()
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar Delegate
 extension ToDoListViewController: UISearchBarDelegate {
    // MARK: SearchBar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
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
