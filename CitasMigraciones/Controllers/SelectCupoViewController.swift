//
//  SelectCupoViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/13/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelectCupoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cupoData:[Cupo] = []
    private let campus:Campus
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var cupoTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cupoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:  "CELL")
        let cupo=cupoData[indexPath.row]
        var type:String = "Agotado"
        if(!cupo.estado){ type = "Libre" }
        
        cell!.textLabel!.text="\(type) - \(cupo.fechaCupo) - \(cupo.sede.nombre)"
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel!.numberOfLines = 4
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(!cupoData[indexPath[1]].estado){
            self.navigationController?.pushViewController(PayRegisterViewController(cupo: cupoData[indexPath[1]]), animated: true)
        }else{
            self.showAlert(title: "Error", message: "Esta Fecha ya ha sido tomada, intete con otro horario.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Horarios"
        campusLabel.text = campus.nombre
        
        loadTableCupos(idSede: campus.idSede)
        
        cupoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    
    init(campus:Campus) {
        self.campus = campus
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadTableCupos(idSede:Int){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "cupo/sede/\(idSede)"
        
        DispatchQueue.main.async {
            Alamofire.request(URL_BASE, method: .get).responseJSON{ (response) in
                switch response.result{
                    
                case .success(let val):
                    let json=JSON(val)
                    let status=json["status"].stringValue
                    let data=json["data"]
                    if(status == "OK"){
                        data.array?.forEach({ (cupo) in
                            let camp = Campus(idSede: cupo["sede"]["idSede"].intValue, nombre: cupo["sede"]["nombre"].stringValue)
                            let cup = Cupo(idCupo: cupo["idCupo"].intValue, sede: camp, fechaCupo: cupo["fechaCupo"].stringValue, estado: cupo["estado"].boolValue)
                            self.cupoData.append(cup)
                            
                            
                            /*if (!cupo["estado"].boolValue){
                                let camp = Campus(idSede: cupo["sede"]["idSede"].intValue, nombre: cupo["sede"]["nombre"].stringValue)
                                let cup = Cupo(idCupo: cupo["idCupo"].intValue, sede: camp, fechaCupo: cupo["fechaCupo"].stringValue, estado: cupo["estado"].boolValue)
                                self.cupoData.append(cup)
                            }else{
                                print("cod cupo -> ",cupo["idCupo"].intValue)
                                print("estado cupo -> ",cupo["estado"].boolValue)
                            }*/
                        })
                        self.cupoTableView.reloadData()
                    }else{
                        self.cupoData = []
                        self.cupoTableView.reloadData()
                        self.showAlert(title: "Error", message: "No se pudo listar los horarios para esta sede")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.cupoData = []
                    self.cupoTableView.reloadData()
                    self.showAlert(title: "Error", message: "No se pudo listar los horarios para esta sede, error en el servicio")
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
