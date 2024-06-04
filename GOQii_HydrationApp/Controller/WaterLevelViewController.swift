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
    
    // MARK: - Variable Declarations
    var screenWidth = UIScreen.main.bounds.width
    lazy var waveView = WaterWaveView()
    var users: [UserDetails]? = []
    var count : Int = 0
    var goal: String = "0"
    private let manager = DatabaseHelper()
    
    // MARK: - Life cycle methods
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
    
    // MARK: IBAction
    @IBAction func glassBottleTap(_ sender: UIButton) {
        if sender.tag == 1 {
            self.count = count + 250
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
            
        } else {
            self.count = count + 150
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        }
        UserDefaults.standard.set(count, forKey: "count")
        checkIfTargetAchieved()
    }
   
    @IBAction func saveWaterData(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: Date())
        let modifiedDate = dateFormatter.date(from: strDate)
        let data = manager.fetchData(entityName: "UserDetails")
        if data?.last?.date == modifiedDate {
            let word = waterIntakeStatusLabel.text?.components(separatedBy: " ").first
            data?.last?.waterIntake = word
            do {
                try DatabaseHelper.appDelegate.persistentContainer.viewContext.save()
            } catch { }
        } else {
            let user = UserModel(id: "\(data?.count ?? 0)" , date: modifiedDate, waterIntake: "\(count)")
            manager.save(entityName: "UserDetails", data: user)
        }
    }
    // MARK: custom function
    func checkIfTargetAchieved() {
        guard let newGoal = Int(goal.components(separatedBy: " ").first ?? "0" ) else { return  }
        if count >= newGoal {
            let alert = UIAlertController(title: "Congratulations", message: "You Achived Your Goal", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    func setupWaveView() {
        waterView.addSubview(waveView)
        waveView.progress = 0.1
        waveView.setUpProgress(waveView.progress)
        waveView.clipsToBounds = true
        NSLayoutConstraint.activate([
            waveView.widthAnchor.constraint(equalToConstant: screenWidth),
            waveView.heightAnchor.constraint(equalToConstant: waveView.progress),
            waveView.centerXAnchor.constraint(equalTo: waterView.centerXAnchor),
            waveView.topAnchor.constraint(equalTo: waterView.topAnchor,constant: 0),
            waveView.bottomAnchor.constraint(equalTo: waterView.bottomAnchor, constant: 0)
        ])
        self.view.layoutIfNeeded()
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
