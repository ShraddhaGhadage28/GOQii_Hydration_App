//
//  HistoryViewController.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var historyTableView: UITableView!
    
    // MARK: - Variable Declarations
    var users: [UserDetails]? = []
    var manager = DatabaseHelper()
    var selectedTarget :String?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        users = manager.fetchData(entityName: "UserDetails") 
        historyTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
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
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTarget = self.users?[indexPath.row].waterIntake
        self.updateAlert(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let userData = self.users {
                self.users?.remove(at: indexPath.row)
                self.manager.deleteData(at: indexPath.row, users: userData)
            }
        }
        historyTableView.reloadData()
    }
    // MARK: - Custom Functions
    func updateAlert(index:Int) {
        let alert = UIAlertController(title: "Water Intake", message: "Update Your Intake", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.text = self.selectedTarget
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(textField?.text)")
            self.users?[index].waterIntake = textField?.text ?? ""
            do {
                try DatabaseHelper.appDelegate.persistentContainer.viewContext.save()
            } catch {}
            self.selectedTarget = "\(textField?.text ?? "0") ml"
            historyTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

