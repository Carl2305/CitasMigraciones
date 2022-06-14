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
        let dni = dniTextField.text!
        let numR = numReciboTextField.text!
        let codV = codVerifyTextField.text!
        let dateP = self.getDateForm(input: payDateDatePicker, format: "yyyy-MM-dd")
        
        // aqui se debe llamar a la funcion que permite registrar
        // una cita mediante el servicio REST
        // si la cita se registra correctamente, debe redirigir al HomeViewController
        
        
        showAlert(title: "Show DATA", message: "dni: \(dni), nRecibo: \(numR), cValida: \(codV), fRegistro: \(dateP)")
        
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
    
    
}
