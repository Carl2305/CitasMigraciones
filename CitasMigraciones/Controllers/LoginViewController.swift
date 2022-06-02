//
//  ViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 5/22/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.borderRound()
        signInButton.borderRound()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        // aqu[i debe llamar a la vista de inicio
        
        //codigo de prueba para lanzar la vista como modal
        /*let storyBoard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        let oPantalla2 = storyBoard.instantiateViewController(withIdentifier: "UserUiView") as! UserViewController
        self.present(oPantalla2, animated: false, completion: nil)*/
         
    }
    
}

