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
    let viewModel = WaterLevelViewModel()
    // MARK: - View Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWaveView()
    }
    override func viewWillAppear(_ animated: Bool) {
        count = viewModel.fetchWaterIntake()
        goal = viewModel.fetchGoal()
        waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        viewModel.setupNotification()
        if count <= 0{
            waveView.setUpProgress(waveView.progress, waterValue: "Please select intake")
        }
        else{
            waveView.setUpProgress(waveView.progress, waterValue: "\(count)")
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
        viewModel.updateCount(count: count)
        waveView.setUpProgress(waveView.progress, waterValue: "\(count)")
        guard let newGoal = Int(goal.components(separatedBy: " ").first ?? "0" ) else { return  }
        if count >= newGoal {
            self.showAlert(title: "Congratulations", msg: "You Achived Your Goal")
        }
    }
    
    @IBAction func resetData(_ sender: UIButton) {
        count = viewModel.fetchWaterIntake()
        waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        waveView.setUpProgress(waveView.progress, waterValue: "\(count)")
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
                self.showAlert(title:"Congratulations",msg:"Your water intake has been saved successfully")
            } catch { }
        } else {
            let user = UserModel(id: "\(data?.count ?? 0)" , date: modifiedDate, waterIntake: "\(count)")
            DatabaseHelper.shared.save(entityName: "UserDetails", data: user)
        }
    }
}
