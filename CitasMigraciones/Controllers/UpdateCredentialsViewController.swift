//
//  UpdateCredentialsViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpdateCredentialsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var lastNameLabel: UITextView!
    @IBOutlet weak var addressLabel: UITextView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title="Credenciales"
        changePasswordButton.borderRound()
    }

    @IBAction func changePasswordButtonAction(_ sender: Any) {
        view.endEditing(true)
        let password = passwordTextField.text!
        let newPassword = newPasswordTextField.text!
        let repeatPassword = repeatPasswordTextField.text!
        let DNI = UsersDefaultsCitasMigraciones.self().getDni()
        
        if(password != ""){
            if(newPassword != ""){
                if(repeatPassword != ""){
                    if(newPassword == repeatPassword){
                        updatePasswordUser(dni: DNI, pass: password, newPass: newPassword)
                    }else{
                        showAlert(title: "Error", message: "La Contraseña y su Confirmación no son Identicas.")
                    }
                }else{
                    showAlert(title: "Error", message: "Ingrese la Contraseña de Confirmación")
                }
            }else{
                showAlert(title: "Error", message: "Ingrese una Nueva Contraseña")
            }
        }else{
            showAlert(title: "Error", message: "Ingrese una Contraseña")
        }
    }
    
    func updatePasswordUser(dni:String, pass:String, newPass:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "auth/ftpass"
        let params = [
            "dni":dni,
            "password":pass,
            "passwordNew":newPass
        ]
        
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                let dataResponse = ApiResponseLogin(success: json["success"].boolValue)
                if (dataResponse.success){
                    self.cleanForm()
                    UsersDefaultsCitasMigraciones().clearUsersDefault()
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    self.cleanForm()
                    self.showAlert(title: "Error", message: "No se pudo actulizar la contraseña, revise sus credenciales")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.cleanForm()
               self.showAlert(title: "Error", message: "No se pudo Actualizar, error en el servicio")
            }
        }
        
    }
    
    func showAlert(title:String, message:String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cleanForm(){
        passwordTextField.text=""
        newPasswordTextField.text=""
        repeatPasswordTextField.text=""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
