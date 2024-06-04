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
    var selectedTarget :String?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        users = DatabaseHelper.shared.fetchData(entityName: "UserDetails")
        historyTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(waterContent: users?[indexPath.row])
        return cell
    }
}
// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
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
                DatabaseHelper.shared.deleteData(at: indexPath.row, users: userData)
            }
        }
        historyTableView.reloadData()
    }
    // MARK: - Custom Functions
   fileprivate func updateAlert(index:Int) {
        let alert = UIAlertController(title: "Water Intake", message: "Update Your Intake", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.text = self.selectedTarget
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, weak alert] (_) in
            let textField = alert?.textFields![0]
            self.users?[index].waterIntake = textField?.text ?? ""
            do {
                try DatabaseHelper.shared.persistentContainer.viewContext.save()
            } catch {}
            self.selectedTarget = "\(textField?.text ?? "0") ml"
            historyTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


