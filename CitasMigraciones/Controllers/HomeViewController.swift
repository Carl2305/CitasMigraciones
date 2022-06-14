//
//  HomeViewController.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var nameUserTextField: UITextView!
    @IBOutlet weak var searchAppointmentButton: UIButton!
    @IBOutlet weak var registerAppointmentButton: UIButton!
    @IBOutlet weak var listCampusButton: UIButton!
    @IBOutlet weak var ChangeCredentialsButton: UIButton!
    @IBOutlet weak var closeSessionButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title="Inicio"
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        searchAppointmentButton.borderRound()
        searchAppointmentButton.borderCyan()
        
        registerAppointmentButton.borderRound()
        registerAppointmentButton.borderGreen()
        
        listCampusButton.borderRound()
        listCampusButton.borderOrange()
        
        ChangeCredentialsButton.borderRound()
        ChangeCredentialsButton.borderDarkBlue()
        
        closeSessionButton.borderRound()
        closeSessionButton.borderRed()
        
    }

    @IBAction func searchAppointmentButtonAction(_ sender: Any) {
        navigationController?.pushViewController(SearchCitaViewController(), animated: true)
    }
    @IBAction func registerAppointmentButtonAction(_ sender: Any) {
        navigationController?.pushViewController(RegisterCitaViewController(), animated: true)
    }
    @IBAction func listCampusButtonAction(_ sender: Any) {
        navigationController?.pushViewController(ListSedeViewController(), animated: true)
    }
    @IBAction func ChangeCredentialsButtonAction(_ sender: Any) {
        navigationController?.pushViewController(UpdateCredentialsViewController(), animated: true)
    }
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        // aqui se deben limpiar las userdefauls
        UsersDefaultsCitasMigraciones().clearUsersDefault()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
