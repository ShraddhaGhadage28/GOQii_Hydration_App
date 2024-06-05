//
//  WaterLevelViewModel.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/4/24.
//

import Foundation
import UserNotifications

class WaterLevelViewModel{
    func fetchWaterIntake() -> Int{
        let strDate = Date().getStringFromDate(dateFormat: DateFormaterStyle.ddMMMYYYY.rawValue)
        let modifiedDate = strDate.getDateFromString(dateFormat: DateFormaterStyle.ddMMMYYYY.rawValue)
        let waterIntake = DatabaseHelper.shared.fetchData(entityName: "UserDetails")
        if let todaysWaterIntake = waterIntake?.first(where: {$0.date == modifiedDate }) {
            return Int(todaysWaterIntake.waterIntake ?? "0") ?? 0
        }
        return 0
    }
    func fetchGoal() -> String{
        if let target =  UserDefaults.standard.value(forKey: "goal") as? String {
            return target
        }
        return "3000 ml"
    }
    func updateCount(count:Int){
        UserDefaults.standard.set(count, forKey: "count")
        UserDefaults.standard.synchronize()
    }
}
// MARK: - Localized Notifications
extension WaterLevelViewModel {
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
        guard let newGoal = Int(self.fetchGoal().components(separatedBy: " ").first ?? "0" ) else { return  }
        if self.fetchWaterIntake() < newGoal {
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
