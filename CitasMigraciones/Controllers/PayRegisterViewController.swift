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
    
    @IBOutlet weak var numReciboTextField: UITextField!
    @IBOutlet weak var codVerifyTextField: UITextField!
    @IBOutlet weak var payDateDatePicker: UIDatePicker!
    @IBOutlet weak var registerCitaButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Registro Pago"
        registerCitaButton.borderRound()
        registerCitaButton.borderGreen()
                
    }

    init(cupo:Cupo) {
        self.cupo = cupo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func registerCitaButtonAction(_ sender: Any) {
        view.endEditing(true)
        let numR = numReciboTextField.text!
        let codV = codVerifyTextField.text!
        let dateP = self.getDateForm(input: payDateDatePicker, format: "yyyy-MM-dd")
        
        if(numR != ""){
            if(numR.count == 6){
                if(codV != ""){
                    if(codV.count == 6){
                        self.rgisterRecibo(numR: numR, codV: codV, date: dateP)
                    }else{
                        showAlert(title: "Error", message: "El código de verificación es de 6 caracteres")
                    }
                }else{
                    showAlert(title: "Error", message: "Ingrese un Código de Verificación")
                }
            }else{
                showAlert(title: "Error", message: "El N° del Recibo es de 6 caracteres")
            }
        }else{
            showAlert(title: "Error", message: "Ingrese un Número de Recibo")
        }
        
    }
    
    func rgisterRecibo(numR:String, codV:String, date:String) {
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
                    self.consultReciboRegister(numR: numR)
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
    
    func consultReciboRegister(numR:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "recibo/cv/\(numR)"
        Alamofire.request(URL_BASE, method: .get, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                if(json["status"].stringValue == "OK"){
                    
                    self.registerCita(cup: self.cupo, idRecb: json["data"]["id_recibo"].intValue, dni: UsersDefaultsCitasMigraciones.self().getDni())
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func registerCita(cup:Cupo, idRecb:Int, dni:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "cita"
        let paramCli:[String:Any] = [
            "dni":"\(dni)"
        ]
        let paramCup:[String:Any] = [
            "idCupo":"\(cup.idCupo)"
        ]
        let paramRicb:[String:Any] = [
            "id_recibo":"\(idRecb)"
        ]
        let params:[String:Any] = [
            "recibo":paramRicb,
            "cupo":paramCup,
            "cliente":paramCli
        ]
        
        Alamofire.request(URL_BASE, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                print("response - > ", json)
                if(json["status"].stringValue == "OK"){
                    self.updateStatusCupo(cp: cup)
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
    
    func updateStatusCupo(cp:Cupo){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "cupo"
        let paramSede:[String:Any] = [
            "idSede":"\(cp.sede.idSede)"
        ]
        let params:[String:Any] = [
            "idCupo":cp.idCupo,
            "sede":paramSede,
            "fechaCupo":cp.fechaCupo
        ]
        
        Alamofire.request(URL_BASE, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result{
                
            case .success(let val):
                let json=JSON(val)
                print("response - > ", json)
                if(json["status"].stringValue == "OK"){
                    self.showAlertRedirectHome(message: "La cita se registro exitosamente!")
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
    
    func showAlertRedirectHome(message:String){
        let alertController=UIAlertController(title: "Cita Registrada", message: message, preferredStyle: .alert)
        let okButtonAction=UIAlertAction(title: "OK", style: .default){
            (action:UIAlertAction) in
            self.cleanForm()
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }
        alertController.addAction(okButtonAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cleanForm(){
        numReciboTextField.text = ""
        codVerifyTextField.text = ""
    }
}
