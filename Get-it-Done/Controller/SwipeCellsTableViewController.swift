//
//  SwipeCellsTableViewController.swift
//  Get-it-Done
//
//  Created by Tory Adderley on 8/12/18.
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellsTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell: UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.reloadData(
//            with: .simple(duration: 0.75, direction: .rotation3D(type: .ironMan),
//                          constantDelay: 0))
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    
    //MARK: - Swipe and Delete Cell Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }

        
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
            
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)

        }
            
        
        deleteAction.image = UIImage(named: "Delete")
        return [deleteAction]
    }
        
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
        }
    
    func updateModel(at indexPath: IndexPath){
        
    }
}
