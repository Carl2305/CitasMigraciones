//
//  UserViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/2/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class UserViewController:UIViewController{
    
    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var lastNameLabel: UITextView!
    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordButton.borderRound()
    }
    
    @IBAction func chagePasswordButtonAction(_ sender: Any) {
    }
}
