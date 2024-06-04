//
//  WaterLevelViewController.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit

class WaterLevelViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var waterIntakeStatusLabel: UILabel!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var glassBtn: UIButton!
    @IBOutlet weak var bottleBtn: UIButton!
    
    // MARK: - Global Variable Declarations
    var users: [UserDetails]? = []
    var count : Int = 0
    var goal: String = "0"
    lazy var waveView = WaterWaveView()
    
    // MARK: - View Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaveView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let target =  UserDefaults.standard.value(forKey: "goal") as? String {
            goal = target
        }
        waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        setupNotification()
    }
}

// MARK: - Self Defined Function
extension WaterLevelViewController {
    fileprivate func checkIfTargetAchieved() {
        guard let newGoal = Int(goal.components(separatedBy: " ").first ?? "0" ) else { return  }
        if count >= newGoal {
            let alert = UIAlertController(title: "Congratulations", message: "You Achived Your Goal", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Wave View
extension WaterLevelViewController {
    fileprivate func setupWaveView() {
        waterView.addSubview(waveView)
        waveView.progress = 0.1
        waveView.setUpProgress(waveView.progress, waterValue: "Please select intake")
        waveView.clipsToBounds = true
        NSLayoutConstraint.activate([
            waveView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            waveView.heightAnchor.constraint(equalToConstant: waveView.progress),
            waveView.centerXAnchor.constraint(equalTo: waterView.centerXAnchor),
            waveView.topAnchor.constraint(equalTo: waterView.topAnchor,constant: 0),
            waveView.bottomAnchor.constraint(equalTo: waterView.bottomAnchor, constant: 0)
        ])
        self.view.layoutIfNeeded()
    }
}

// MARK: - Ibaction Tapped Event
extension WaterLevelViewController {
    @IBAction func glassBottleTap(_ sender: UIButton) {
        if sender.tag == 1 {
            self.count = count + 250
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
            
        } else {
            self.count = count + 150
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        }
        UserDefaults.standard.set(count, forKey: "count")
        waveView.setUpProgress(0, waterValue: "\(count)")
        
        checkIfTargetAchieved()
    }
    
    @IBAction func saveWaterData(_ sender: UIButton) {
        let strDate = Date().getStringFromDate(dateFormat: DateFormaterStyle.ddMMMYYYY.rawValue)
        let modifiedDate = strDate.getDateFromString(dateFormat: DateFormaterStyle.ddMMMYYYY.rawValue)
        let data = DatabaseHelper.shared.fetchData(entityName: "UserDetails")
        if data?.last?.date == modifiedDate {
            let word = waterIntakeStatusLabel.text?.components(separatedBy: " ").first
            data?.last?.waterIntake = word
            do {
                try DatabaseHelper.shared.persistentContainer.viewContext.save()
            } catch { }
        } else {
            let user = UserModel(id: "\(data?.count ?? 0)" , date: modifiedDate, waterIntake: "\(count)")
            DatabaseHelper.shared.save(entityName: "UserDetails", data: user)
        }
    }
}

// MARK: - Localized Notifications
extension WaterLevelViewController {
    func setupNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.scheduleNotifications()
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleNotifications() {
        guard let newGoal = Int(goal.components(separatedBy: " ").first ?? "0" ) else { return  }
        if count < newGoal {
            scheduleNotification(hour: 15, minute: 00)
            scheduleNotification(hour: 17, minute: 30)
        }
    }
    
    func scheduleNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Drink Water"
        content.body = "Don't forget to complete your goal!"
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "\(hour)-\(minute)-Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
}

extension Date {
    func getStringFromDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
    
}

extension String {
    func getDateFromString(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}

enum DateFormaterStyle: String {
    case ddMMMYYYY = "dd MMM yyyy"
}
