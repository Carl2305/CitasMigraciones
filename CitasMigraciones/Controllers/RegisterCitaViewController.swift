//
//  RegisterCitaViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/13/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterCitaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var campusData:[Campus] = []
    @IBOutlet weak var campusTableView: UITableView!
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier:  "CELL")
        let campus=campusData[indexPath.row]
        cell!.textLabel!.text=campus.nombre
        cell!.textLabel!.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel!.numberOfLines = 2
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(SelectCupoViewController(campus: campusData[indexPath[1]]), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title="Sedes"
        
        loadTableCampus()
        
        campusTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }

    func loadTableCampus(){
        let URL_BASE:String = ConstantsCitasMigraciones.self().URL_BASE_API + "sede/all"
        
        DispatchQueue.main.async {
            Alamofire.request(URL_BASE, method: .get).responseJSON{ (response) in
                switch response.result{
                    
                case .success(let val):
                    let json=JSON(val)
                    let status=json["status"].stringValue
                    let data=json["data"]
                    if(status == "OK"){
                        data.array?.forEach({ (campus) in
                            let camp = Campus(idSede: campus["idSede"].intValue, nombre: campus["nombre"].stringValue)
                            self.campusData.append(camp)
                        })
                        self.campusTableView.reloadData()
                    }else{
                        self.campusData = []
                        self.campusTableView.reloadData()
                        self.showAlert(title: "Error", message: "No se pudo listar las sedes")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.campusData = []
                    self.campusTableView.reloadData()
                    self.showAlert(title: "Error", message: "No se pudo listar las sedes, error en el servicio")
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
