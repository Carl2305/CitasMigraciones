//
//  LoginViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 5/22/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

    private let isLogued = UsersDefaultsCitasMigraciones.self().getIsLogued()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.borderRound()
        signInButton.borderRound()
        self.navigationController?.isNavigationBarHidden = true
        
        if(self.isLogued){
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }
        
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        view.endEditing(true)
        let dni = dniTextField.text!
        let password = passwordTextField.text!
        
        if(dni != ""){
            if(dni.count == 8){
                if(password != ""){
                    LogInUser(dni: dni, password: password)
                }else{
                    showAlert(title: "Error", message: "Ingrese su Contraseña")
                }
            }else{
                showAlert(title: "Error", message: "El Documento de Identidad debe ser de 8 caracteres")
            }
        }else{
            showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
        }
        
    }
    
    func LogInUser(dni:String, password:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "auth/signIn"
        
        let params = [
            "dni":dni,
            "password":password
        ]
        
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let val):
                let json=JSON(val)
                let dataResponse = ApiResponseLogin(success: json["success"].boolValue)
                if (dataResponse.success){
                    self.getUserForSetUserDefaults(dni: dni)
                    self.cleanForm()
                }else{
                    UsersDefaultsCitasMigraciones().clearUsersDefault()
                    self.cleanForm()
                    self.showAlert(title: "Error", message: "No se pudo acceder, revise sus credenciales")
                }
            case .failure(let error):
                UsersDefaultsCitasMigraciones().clearUsersDefault()
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: "No se pudo acceder, error en el servicio")
            }
        }
    }
    
    func getUserForSetUserDefaults(dni:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "auth/listaPorDNI/\(dni)"
        Alamofire.request(URL_BASE, method: .post, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                if(json["status"].stringValue=="OK"){
                    UsersDefaultsCitasMigraciones.self().saveIsLogued(signIn: true)
                    UsersDefaultsCitasMigraciones.self().saveAndPutDni(dni: json["data"]["dni"].stringValue)
                    UsersDefaultsCitasMigraciones.self().saveAndPutDateBirthDate(date: json["data"]["fechaNac"].stringValue)
                    UsersDefaultsCitasMigraciones.self().saveAndPutAddress(address: json["data"]["direccion"].stringValue)
                    UsersDefaultsCitasMigraciones.self().saveAndPutEmail(email: json["data"]["correo"].stringValue)
                    UsersDefaultsCitasMigraciones.self().saveAndPutName(name: json["data"]["nombre"].stringValue)
                    UsersDefaultsCitasMigraciones.self().saveAndPutLastName(last: "\(json["data"]["apePaterno"].stringValue) \(json["data"]["apeMaterno"].stringValue)")

                    // redirige al home
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
                }else{
                     return
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showAlert(title:String, message:String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cleanForm(){
        dniTextField.text=""
        passwordTextField.text=""
    }
}
