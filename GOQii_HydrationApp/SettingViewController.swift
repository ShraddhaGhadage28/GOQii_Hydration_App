//
//  SettingViewController.swift
//  GOQii_HydrationApp
//
//  Created by Shraddha Ghadage on 6/3/24.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var goalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGesture()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let target =  UserDefaults.standard.value(forKey: "goal") as? String {
            goalLabel.text = target
        }
    }
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goalViewTapped(_:)))
        goalView.addGestureRecognizer(tapGesture)
    }
    @objc func goalViewTapped(_ sender: UITapGestureRecognizer) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Your Goal", message: "Edit Your Goal", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            let word = self.goalLabel.text?.components(separatedBy: " ").first
            textField.text = word
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            self.goalLabel.text = "\(textField?.text ?? "0") ml"
            UserDefaults.standard.set(self.goalLabel.text, forKey: "goal")
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
