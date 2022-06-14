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
        
        if(self.isValidDni){
            validatorDniButton.isEnabled = false
            signUpButton.isEnabled = true
        }else{
            validatorDniButton.isEnabled = true
            signUpButton.isEnabled = false
        }
        
    }
    @IBAction func validatorDniButtonAction(_ sender: Any) {
        let dni=dniTextField.text!
        if(dni != ""){
            // aqui llama al servicio para validar el DNI
            self.isValidDni = true
            signUpButton.isEnabled = true
        }else{
            showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let dni=dniTextField.text!
        let date=getDateForm(input: dateBirthDatePicker, format: "yyyy-MM-dd")
        let address=addressTextField.text!
        let email=emailTextField.text!
        let password=passwordTextField.text!
        let repeatPassword=repeatPasswordTextField.text!
        
        if(self.isValidDni){
            if(dni != ""){
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
                validatorDniButton.isEnabled = true
                signUpButton.isEnabled = false
                showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
            }
        }else{
            showAlert(title: "Error", message: "Antes debe validar su Documento de Identidad")
        }
        
    }
    
    func getDateForm(input:UIDatePicker,format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: input.date)
        return strDate
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
                    self.cleanForm()
                    // redireige la home
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    
                }else{
                    self.cleanForm()
                    self.showAlert(title: "Error", message: "No se pudo Registrar")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.cleanForm()
               self.showAlert(title: "Error", message: "No se pudo Registrar, error en el servicio")
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
        addressTextField.text=""
        emailTextField.text=""
        passwordTextField.text=""
        repeatPasswordTextField.text=""
        self.isValidDni = false
        validatorDniButton.isEnabled = true
        signUpButton.isEnabled = false
    }
}
