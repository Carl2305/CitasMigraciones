//
//  SignUpViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/2/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController:UIViewController{
    
    
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var validatorDniButton: UIButton!
    @IBOutlet weak var dateBirthDatePicker: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var isValidDni:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.borderRound()
        validatorDniButton.borderRound()
        validatorDniButton.borderGreen()
        
        if(!self.isValidDni){
            dniTextField.text = ""
            validatorDniButton.isEnabled = true
            dniTextField.isEnabled = true
            signUpButton.isEnabled = false
            addressTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            repeatPasswordTextField.isEnabled = false
        }else{
            self.cleanForm()
        }
        
    }
    @IBAction func validatorDniButtonAction(_ sender: Any) {
        let dni=dniTextField.text!
        if(dni != ""){
            self.validateDNI(dni: dni)
        }else{
            showAlert(title: "Error", message: "Ingrese un Documento de Identidad para Validar")
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        let dni=dniTextField.text!
        let date=getDateForm(input: dateBirthDatePicker, format: "yyyy-MM-dd")
        let address=addressTextField.text!
        let email=emailTextField.text!
        let password=passwordTextField.text!
        let repeatPassword=repeatPasswordTextField.text!
        
        if(self.isValidDni){
            if(dni != ""){
                if(dni.count == 8){
                    if(date != ""){
                        if(address != ""){
                            if(email != ""){
                                if(password != ""){
                                    if(repeatPassword != ""){
                                        if(password == repeatPassword){
                                            signUpUser(dni: dni, date: date, address: address, email: email, password: password)
                                        }else{
                                            showAlert(title: "Error", message: "La Contraseña y su Confirmación no son Identicas.")
                                        }
                                    }else{
                                        showAlert(title: "Error", message: "Ingrese la Contraseña de Confirmación")
                                    }
                                }else{
                                    showAlert(title: "Error", message: "Ingrese una Contraseña")
                                }
                            }else{
                                showAlert(title: "Error", message: "Ingrese un Correo Electrónico")
                            }
                        }else{
                            showAlert(title: "Error", message: "Ingrese una Dirección")
                        }
                    }else{
                        showAlert(title: "Error", message: "Seleccione una Fecha de Nacimiento")
                    }
                }else{
                    showAlert(title: "Error", message: "El Documento de Identidad debe ser de 8 caracteres")
                }
            }else{
                validatorDniButton.isEnabled = true
                dniTextField.isEnabled = true
                signUpButton.isEnabled = false
                addressTextField.isEnabled = false
                emailTextField.isEnabled = false
                passwordTextField.isEnabled = false
                repeatPasswordTextField.isEnabled = false
                showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
            }
        }else{
            showAlert(title: "Error", message: "Antes debe validar su Documento de Identidad")
        }
        
    }
    
    func validateDNI(dni:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "auth/validarDNI/\(dni)"
        Alamofire.request(URL_BASE, method: .get, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                let dataResponse = ApiResponseCreated(mensaje: json["mensaje"].stringValue, status: json["status"].stringValue)
                if(dataResponse.status=="OK"){
                    self.showAlertValidateSuccessOrError(message: "¿Son sus datos correctos? Nombres: \(dataResponse.mensaje)")
                }else{
                    self.showAlert(title: "Error Validación", message: "No se pudo validar el DNI.")
                    self.validatorDniButton.isEnabled = true
                    self.dniTextField.isEnabled = true
                    self.isValidDni = false
                    self.signUpButton.isEnabled = false
                    self.addressTextField.isEnabled = false
                    self.emailTextField.isEnabled = false
                    self.passwordTextField.isEnabled = false
                    self.repeatPasswordTextField.isEnabled = false
                }
            case .failure(let error):
                print(error.localizedDescription)
               self.showAlert(title: "Error", message: "No se pudo validar el DNI, error en el servicio")
            }
        }
    }
    
    func signUpUser(dni:String,date:String,address:String,email:String,password:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "auth/signUp"
        let params = [
            "dni":dni,
            "correo":email,
            "password":password,
            "direccion":address,
            "fechaNac":date
        ]
        
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                let dataResponse = ApiResponseCreated(mensaje: json["mensaje"].stringValue, status: json["status"].stringValue)
                if(dataResponse.status=="OK"){
                    self.getUserForSetUserDefaults(dni: dni)
                    self.cleanForm()
                }else{
                    self.cleanForm()
                    self.showAlert(title: "Error", message: dataResponse.mensaje)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.cleanForm()
               self.showAlert(title: "Error", message: "No se pudo Registrar, error en el servicio")
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
                    self.showAlertRegister()
                }else{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getDateForm(input:UIDatePicker,format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: input.date)
        return strDate
    }
    
    func showAlert(title:String, message:String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertRegister(){
        let alert=UIAlertController(title: "Registro Exitoso", message: "Se registró el usuario, ahora puede ir al inicio de sesión", preferredStyle: .alert)
        
        let okButtonAction=UIAlertAction(title: "OK", style: .default){
            (action:UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okButtonAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertValidateSuccessOrError(message:String){
        let alert=UIAlertController(title: "Validación Exitosa", message: message, preferredStyle: .alert)
        
        let okButtonAction=UIAlertAction(title: "Si, es Correcto", style: .default){
            (action:UIAlertAction) in
            self.validatorDniButton.isEnabled = false
            self.dniTextField.isEnabled = false
            self.isValidDni = true
            self.signUpButton.isEnabled = true
            self.addressTextField.isEnabled = true
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.repeatPasswordTextField.isEnabled = true
        }
        
        let cancelButtonAction=UIAlertAction(title: "No", style: .default){
            (action: UIAlertAction) in
            self.cleanForm()
        }
        
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func cleanForm(){
        dniTextField.text=""
        addressTextField.text=""
        emailTextField.text=""
        passwordTextField.text=""
        repeatPasswordTextField.text=""
        self.isValidDni = false
        validatorDniButton.isEnabled = true
        dniTextField.isEnabled = true
        signUpButton.isEnabled = false
        addressTextField.isEnabled = false
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        repeatPasswordTextField.isEnabled = false
    }
}
