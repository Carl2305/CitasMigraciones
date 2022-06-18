//
//  SearchCitaViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchCitaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchCitaTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var citaTableView: UITableView!
    
    var citaData:[Cita] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citaData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:  "CELL")
        let cita=citaData[indexPath.row]
        cell!.textLabel!.text="\(cita.cliente.nombre) - \(cita.fechaRegistro)"
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 14)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DescriptionSearchCitaViewController(cita: citaData[indexPath[1]]), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title="Consultas"
        searchButton.borderRound()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        let dni=searchCitaTextField.text!
        
        if (dni != ""){
            if(dni.count == 8){
                self.citaData = []
                loadTableCitas(dni: dni)
                citaTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
            }else{
                showAlert(title: "Error", message: "El Documento de Identidad debe ser de 8 caracteres")
            }
        }else{
            self.showAlert(title: "Error", message: "Ingrese un Documento de Identidad")
        }
        
    }
    
    func loadTableCitas(dni:String){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "cita/DNI/\(dni)"
        
        DispatchQueue.main.async {
            Alamofire.request(URL_BASE, method: .get).responseJSON{ (response) in
                switch response.result{
                    
                case .success(let val):
                    let json=JSON(val)
                    let status=json["status"].stringValue
                    let data=json["data"]
                    if(status == "OK"){
                        if(!data.isEmpty){
                            data.array?.forEach({ (cita) in
                                let recib:Recibo = Recibo(id_recibo: cita["recibo"]["id_Recibo"].intValue, codigoVoucher: cita["recibo"]["codigoVoucher"].stringValue, codigoVerificacion: cita["recibo"]["codigoVerificacion"].stringValue, fechaPago: cita["recibo"]["fechaPago"].stringValue)
                                
                                let camp:Campus = Campus(idSede: cita["cupo"]["sede"]["idSede"].intValue, nombre: cita["cupo"]["sede"]["nombre"].stringValue)
                                
                                let cup:Cupo = Cupo(idCupo: cita["cupo"]["idCupo"].intValue, sede: camp, fechaCupo: cita["cupo"]["fechaCupo"].stringValue, estado: cita["cupo"]["estado"].boolValue)
                                
                                let cli:Cliente = Cliente(nombre: cita["cliente"]["nombre"].stringValue, apePaterno: cita["cliente"]["apePaterno"].stringValue, apeMaterno: cita["cliente"]["apeMaterno"].stringValue, correo: cita["cliente"]["correo"].stringValue, password: "", direccion: cita["cliente"]["direccion"].stringValue, fechaNac: cita["cliente"]["fechaNac"].stringValue, dni: cita["cliente"]["dni"].stringValue)
                                
                                
                                let cit = Cita(idCita: cita["idCita"].intValue, fechaRegistro: cita["fechaRegistro"].stringValue, recibo: recib, cupo: cup, cliente: cli)
                            
                                
                                self.citaData.append(cit)
                                self.citaTableView.reloadData()
                            })
                        }else{
                            self.citaData = []
                            self.citaTableView.reloadData()
                            self.showAlert(title: "Error", message: "No hay Citas con el DNI ingresado")
                        }
                    }else{
                       self.citaData = []
                        self.citaTableView.reloadData()
                        self.showAlert(title: "Error", message: "No se pudo listar las citas")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                     self.citaData = []
                    self.citaTableView.reloadData()
                   self.showAlert(title: "Error", message: "No se pudo listar las citas, error en el servicio")
                }
            }
        }
    }
    
    func showAlert(title:String, message:String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
