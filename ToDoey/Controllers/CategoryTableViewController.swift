//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 17/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    let GO_TO_ITEMS = "goToItems"
    let CATEGORY_CELL = "CategoryCell"
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.reloadData()
    }
    
    // MARK: Add new category
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Create new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            if let text = textField.text {
                let category = Category()
                category.title = text
                // category array will update automatically
//                self.categoryArray.append(category)
                self.saveCategory(category: category)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
     }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CATEGORY_CELL, for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? "No categories added yet"
        if categoryArray == nil {
            cell.textLabel?.textColor = UIColor.gray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: GO_TO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GO_TO_ITEMS {
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    
    //MARK: Data Manipulation  Methods
    func loadCategories() {
        categoryArray = realm.objects(Category.self)
    }
    
    func saveCategory(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context\(error)")
        }
    }

}
