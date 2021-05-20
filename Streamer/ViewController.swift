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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Streamer"
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


}

