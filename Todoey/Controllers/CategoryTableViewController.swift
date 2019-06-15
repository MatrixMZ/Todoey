//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mateusz Ziobrowski on 14/06/2019.
//  Copyright © 2019 Mateusz Ziobrowski. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category: Category = Category()
            category.name = textField.text!
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category name..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Displaying data in the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet!"
        return cell
    }
    
    //MARK: Opening items view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewContoller = segue.destination as! TodoListViewController
        
        if let selectedCategoryCell = tableView.indexPathForSelectedRow {
            destinationViewContoller.selectedCategory = categories?[selectedCategoryCell.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    //MARK: CRUD Methods
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
        } catch {
            print("Saving category error: \(error)")
        }
    }
}
