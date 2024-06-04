//
//  WaterLevelViewController.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit

class WaterLevelViewController: UIViewController {
    @IBOutlet weak var waterIntakeStatusLabel: UILabel!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var glassBtn: UIButton!
    @IBOutlet weak var bottleBtn: UIButton!
    
    var screenWidth = UIScreen.main.bounds.width
        // MARK: - Properties -
    lazy var waveView = WaterWaveView()
        var circularProgressBarView: CircularProgressBarView!
        var circularViewDuration: TimeInterval = 2
    var count : Int = 0
    var goal: String = "0"
    private let manager = SaveData()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpCircularProgressBarView()
        
        setupWaveView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let target =  UserDefaults.standard.value(forKey: "goal") as? String {
            goal = target
        }
        waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
    }
    @IBAction func glassBottleTap(_ sender: UIButton) {
        if sender.tag == 1 {
            self.count = count + 250
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        } else {
            self.count = count + 150
            waterIntakeStatusLabel.text = "\(count) ml out of \(goal)"
        }
        //checkIfTargetAchieved()
    }
    
    @IBAction func saveWaterData(_ sender: UIButton) {
      let user = UserModel(id:"1" , date: Date(), waterIntake: "\(count)")
        manager.save(entityName: "UserDetails", data: user)
      
    }
    func checkIfTargetAchieved() {
        guard let target = goal as? Int else { return  }
        if target < count {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Congratulations", message: "You Achived Your Goal", preferredStyle: .alert)
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true)
            }))

            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    func setUpCircularProgressBarView() {
            // set view
            circularProgressBarView = CircularProgressBarView(frame: .zero)
            // align to the center of the screen
            circularProgressBarView.center = view.center
            // call the animation with circularViewDuration
            circularProgressBarView.progressAnimation(duration: circularViewDuration)
            // add this view to the view controller
            view.addSubview(circularProgressBarView)
        }
        
        func setupWaveView() {
            waterView.addSubview(waveView)
            waveView.progress = 0.1
            waveView.setUpProgress(waveView.progress)
//            waveView.layer.cornerRadius = screenWidth * 0.48 / 2
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
