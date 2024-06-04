//
//  HistoryViewController.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyTableView: UITableView!
    var users: [UserDetails]? = []
    var manager = SaveData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        users = manager.fetchData(entityName: "UserDetails") 
        historyTableView.reloadData()
    }
    public func deleteData(at index: Int) {
            let context = SaveData.appDelegate.persistentContainer.viewContext
            
            // Fetch the specific UserDetails object to delete
        guard let userToDelete = users?[index] else { return  }
            context.delete(userToDelete)
            
            do {
                try context.save()
            } catch {
                print("Failed to save context after deletion: \(error)")
            }
        }
}

extension HistoryViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        let usersData = users?[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.string(from: usersData?.date ?? Date())
        cell.dateLabel.text = date
        cell.waterIntakeLabel.text = "\(usersData?.waterIntake ?? "0") ml"
        return cell
    }
   
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true // Allow all rows to be editable
        }
    /*
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             if let userData = users {
                 self.users?.remove(at: indexPath.row)
                 manager.deleteData(at: indexPath.row, users: userData)
             }
                 self.historyTableView.reloadData()
            
         }

        }*/
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            if let userData = self.users {
                self.users?.remove(at: indexPath.row)
                self.manager.deleteData(at: indexPath.row, users: userData)
            }
                self.historyTableView.reloadData()
        }
        let update = UIContextualAction(style: .destructive, title: "Update") {_,_,_ in
        
        }
        update.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [delete,update])
    }
   
}

