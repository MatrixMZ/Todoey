//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Mateusz Ziobrowski on 14/06/2019.
//  Copyright © 2019 Mateusz Ziobrowski. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories: [Category] = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category: Category = Category(context: self.context)
            category.name = textField.text!
            self.categories.append(category)
            self.saveCategories()
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: Opening items view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewContoller = segue.destination as! TodoListViewController
        
        if let selectedCategoryCell = tableView.indexPathForSelectedRow {
            destinationViewContoller.selectedCategory = categories[selectedCategoryCell.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    //MARK: CRUD Methods
    
    func loadCategories() {
        do {
            categories = try context.fetch(Category.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Loading category error: \(error)")
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Saving category error: \(error)")
        }
    }
}
