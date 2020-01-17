//
//  SwipeTableViewController.swift
//  ToDoey
//
//  Created by Evgeniy Uskov on 05/08/2019.
//  Copyright © 2019 Evgeniy Uskov. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let CELL = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL, for: indexPath)  as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    //MARK: SwipeTableViewCellDelegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //swipe from right
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("***delete SUPERCLASS ACTION - SwipeTableViewController")
            
            // call updateModel()
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        print("***delete from SUPERCLASS updateModel()")
    }
}
