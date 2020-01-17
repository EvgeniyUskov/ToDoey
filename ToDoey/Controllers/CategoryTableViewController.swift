//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 17/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    let GO_TO_ITEMS = "goToItems"
    let CATEGORY_CELL = "CategoryCell"
    let allowedColors = [
        FlatRed(),
        FlatOrange(),
        FlatYellow(),
        FlatGreen(),
        FlatBlue(),
        FlatPurple()]
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        tableView.reloadData()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
            let navBarColour = FlatSkyBlue()
                guard let navBar = navigationController?.navigationBar else { fatalError("NavigationController doesn't exist")}
                navBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
    }
    
    // MARK: Add new category
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add  new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let text = textField.text {
                let category = Category()
                category.title = text
                category.hexBackgroundColor = ((UIColor(randomColorIn: self.allowedColors)?.hexValue())!)
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? "No categories added yet"
        cell.backgroundColor = UIColor (hexString: categoryArray?[indexPath.row].hexBackgroundColor ?? FlatWhite().hexValue())
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
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
    
    // Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        print("***delete SUBCLASS ACTION - CategoryViewController")
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion )
                }
            }
            catch {
                print("error deleteing Category\(error)")
            }
        }
    }

}
