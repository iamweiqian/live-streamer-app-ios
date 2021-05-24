//
//  ViewController.swift
//  Streamer
//
//  Created by Wei Qian Yap on 20/05/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var streamerNameTextField: UITextField!
    @IBOutlet weak var startLiveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startLiveButton.isEnabled = false
        streamerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Streamer"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @IBAction func startLiveButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "startLive", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startLive") {
            let destination = segue.destination as! StreamingViewController
            if let streamerName = streamerNameTextField.text {
                destination.streamerName = streamerName
            }
        }
    }
    
    
}

extension ViewController {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.trim()
        if textField == streamerNameTextField {
            startLiveButton.isEnabled = !(textField.text?.isEmpty ?? true)
        }
    }
    
}
