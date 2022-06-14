//
//  DescriptionSearchCitaViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/13/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class DescriptionSearchCitaViewController: UIViewController {
    
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateRegisterLabel: UILabel!
    private let cita:Cita
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Cita N° \(cita.idCita)"
        
        dniLabel.text=cita.cliente.dni
        dateLabel.text=cita.cupo.fechaCupo
        campusLabel.text=cita.cupo.sede.nombre
        clientLabel.text="\(cita.cliente.nombre), \(cita.cliente.apePaterno) \(cita.cliente.apeMaterno)"
        emailLabel.text=cita.cliente.correo
        dateRegisterLabel.text=cita.fechaRegistro
        
    }
    
    init(cita:Cita){
        self.cita = cita
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
