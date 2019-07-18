//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 17/07/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let GO_TO_ITEMS = "goToItems"
    let CATEGORY_CELL = "CategoryCell"
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }
    
    // MARK: Add new category
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Create new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new category", style: .default) { (action) in
            if let text = textField.text {
                let category = Category(context: self.context)
                category.title = text
                self.categoryArray.append(category)
                self.saveData()
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
     }
    
    //MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CATEGORY_CELL, for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: GO_TO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GO_TO_ITEMS {
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    
    //MARK: Data Manipulation  Methods
    func saveData() {
        do{
            try context.save()
        } catch {
            print("error saving context\(error)")
        }
    }
    
    // method with default value for the parameter if undefined
    func loadData() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching data from context\(error)")
        }
    }
    

}
