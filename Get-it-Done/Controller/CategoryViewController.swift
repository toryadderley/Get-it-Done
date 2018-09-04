//
//  CategoryViewController.swift
//  Get-it-Done
//
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView
import TableViewReloadAnimation


class CategoryViewController: SwipeCellsTableViewController {
    
    let realm = try! Realm()
    
    var categoryList: Results<Category>?

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        Utils.insertGradientIntoTableView(viewController: self, tableView: tableview)
        Utils.navBarClear(viewController: self)
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Categories"
        cell.selectionStyle = .none
        cell.backgroundColor =  UIColor.clear

        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatioVC = segue.destination as! ListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinatioVC.selectedCategory = categoryList?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category: Category) {
        do {
            try realm.write { realm.add(category) } 
        } catch{
            print("Error writing Categories")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories()  {
        categoryList = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let categorytoDelete = self.categoryList?[indexPath.row]{
            
            do {
                try self.realm.write { self.realm.delete(categorytoDelete) }
            } catch{
                print("Error deleting the category")
                }
            }
    }
    
    //MARK: - Add New Category Method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kCircleHeight: 100.0,
            kCircleIconHeight: 60.0,
            kTitleTop: 62.0,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "Flexed_Biceps_Emoji")
        let textField = alertView.addTextField("Enter New Task")
        
        alertView.addButton("Add") {
            if !textField.text!.isEmpty {
                let newCategory = Category()
                newCategory.name = textField.text!
                self.saveCategories(category: newCategory)
            }
        }
        alertView.addButton("Close") {}
        
        alertView.showCustom("Add New Task", subTitle: "" , color: Utils.hexStringToUIColor(hex: "fa709a"), icon: alertViewIcon!, animationStyle: .rightToLeft)
        
    }
    
    
    
}
