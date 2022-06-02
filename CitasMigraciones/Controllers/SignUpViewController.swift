//
//  SignUpViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/2/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class SignUpViewController:UIViewController{
    
    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var dateBirthDatePicker: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.borderRound()
    }
}
