//
//  PayRegisterViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/13/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PayRegisterViewController: UIViewController {

    private let cupo:Cupo
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var numReciboTextField: UITextField!
    @IBOutlet weak var codVerifyTextField: UITextField!
    @IBOutlet weak var payDateDatePicker: UIDatePicker!
    @IBOutlet weak var registerCitaButton: UIButton!
    @IBOutlet weak var validateDniButton: UIButton!
    
    private var isValidDni:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Registro Pago"
        registerCitaButton.borderRound()
        registerCitaButton.borderGreen()
        
        validateDniButton.borderRound()
        validateDniButton.borderCyan()
        
        if(!self.isValidDni){
            dniTextField.text = ""
            validateDniButton.isEnabled = true
            dniTextField.isEnabled = true
            registerCitaButton.isEnabled = false
            numReciboTextField.isEnabled = false
            codVerifyTextField.isEnabled = false
        }else{
            self.cleanForm()
        }
        
    }

    init(cupo:Cupo) {
        self.cupo = cupo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func validateDniButtonAction(_ sender: Any) {
        let dni=dniTextField.text!
        if(dni != ""){
            self.validateDNI(dni: dni)
        }else{
            showAlert(title: "Error", message: "Ingrese un Documento de Identidad para Validar")
        }
    }
    
    @IBAction func registerCitaButtonAction(_ sender: Any) {
        view.endEditing(true)
        let dni = dniTextField.text!
        let numR = numReciboTextField.text!
        let codV = codVerifyTextField.text!
        let dateP = self.getDateForm(input: payDateDatePicker, format: "yyyy-MM-dd")
        
        if(self.isValidDni){
            if(dni != ""){
                if(numR != ""){
                    if(codV != ""){
                        // aqui se debe llamar a la funcion que permite registrar
                        // una cita mediante el servicio REST
                        // si la cita se registra correctamente, debe redirigir al HomeViewController
                        
                        // esta es la funcion que se debe llamar -> rgisterRecibo(dni, numR, codV, date)
                        
                        // funcion momentanea
                        showAlert(title: "Show DATA", message: "dni: \(dni), nRecibo: \(numR), cValida: \(codV), fRegistro: \(dateP)")
                        
                    }else{
                        showAlert(title: "Error", message: "Ingrese un Código de Verificación")
                    }
                }else{
                    showAlert(title: "Error", message: "Ingrese un Número de Recibo")
                }
            }else{
                validateDniButton.isEnabled = true
                dniTextField.isEnabled = true
                registerCitaButton.isEnabled = false
                numReciboTextField.isEnabled = false
                codVerifyTextField.isEnabled = false
                showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
            }
        }else{
            showAlert(title: "Error", message: "Antes debe validar su Documento de Identidad")
        }
    }
    
    func rgisterRecibo(dni:String, numR:String, codV:String, date:String) {
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "recibo"
        let params = [
            "codigoVoucher":numR,
            "codigoVerificacion":codV,
            "fechaPago":date
        ]
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                let dataResponse = ApiResponseCreated(mensaje: json["mensaje"].stringValue, status: json["status"].stringValue)
                if(dataResponse.status=="OK"){
                    self.consultReciboRegister(dni: dni, numR: numR)
                }else{
                    self.cleanForm()
                    self.showAlert(title: "Error", message: dataResponse.mensaje)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.cleanForm()
               self.showAlert(title: "Error", message: "No se pudo Registrar el Recibo, error en el servicio")
            }
        }
    }
    
    func consultReciboRegister(dni:String, numR:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "recibo/cv/\(numR)"
        Alamofire.request(URL_BASE, method: .get, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                if(json["status"].stringValue == "OK"){
                    let recibo:Recibo = Recibo(id_recibo: json["data"]["id_recibo"].intValue, codigoVoucher: json["data"]["codigoVoucher"].stringValue,
                                               codigoVerificacion: json["data"]["codigoVerificacion"].stringValue, fechaPago: json["data"]["fechaPago"].stringValue)
                    let client:Cliente = Cliente(nombre: "", apePaterno: "", apeMaterno: "", correo: "", password: "", direccion: "", fechaNac: "", dni: dni)
                    // aqui se debe llamar a la funcion que registra la cita en la DB
                    // la funcion que se debe llamar  es -> registerCita()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func registerCita(cup:Cupo, recb:Recibo, cli:Cliente){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "cita"
        let params = [
            "recibo":recb,
            "cupo":cup,
            "cliente":cli
            ] as [String : Any] 
        
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                if(json["status"].stringValue == "OK"){
                    // sedebe redirigir al home
                }else{
                    self.cleanForm()
                    self.showAlert(title: "Error", message: "No se pudo registrar la cita.")
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.cleanForm()
               self.showAlert(title: "Error", message: "No se pudo Registrar la Cita, error en el servicio")
            }
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
                    self.showAlertValidateSuccessOrError(message: "¿Quieres Registrar una Cita a este Nombre: \(dataResponse.mensaje)?")
                }else{
                    self.showAlert(title: "Error Validación", message: "No se pudo validar el DNI.")
                    self.validateDniButton.isEnabled = true
                    self.dniTextField.isEnabled = true
                    self.isValidDni = false
                    self.registerCitaButton.isEnabled = false
                    self.numReciboTextField.isEnabled = false
                    self.codVerifyTextField.isEnabled = false
                }
            case .failure(let error):
                print(error.localizedDescription)
               self.showAlert(title: "Error", message: "No se pudo validar el DNI, error en el servicio")
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
    
    func showAlertValidateSuccessOrError(message:String){
        let alert=UIAlertController(title: "Validación Exitosa", message: message, preferredStyle: .alert)
        
        let okButtonAction=UIAlertAction(title: "Si, es Correcto", style: .default){
            (action:UIAlertAction) in
            self.validateDniButton.isEnabled = false
            self.dniTextField.isEnabled = false
            self.isValidDni = true
            self.registerCitaButton.isEnabled = true
            self.numReciboTextField.isEnabled = true
            self.codVerifyTextField.isEnabled = true
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
        dniTextField.text = ""
        numReciboTextField.text = ""
        codVerifyTextField.text = ""
        self.isValidDni = false
        validateDniButton.isEnabled = true
        dniTextField.isEnabled = true
        registerCitaButton.isEnabled = false
        numReciboTextField.isEnabled = false
        codVerifyTextField.isEnabled = false
    }
}
