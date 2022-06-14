//
//  UsersDefaultsCitasMigraciones.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class UsersDefaultsCitasMigraciones{
    private let KEY_DNI="MY_KEY_DNI"
    private let KEY_DATE_BIRTHDATE="MY_KEY_DATE_BIRTHDATE"
    private let KEY_ADDRESS="MY_KEY_ADDRESS"
    private let KEY_EMAIL="MY_KEY_EMAIL"
    
    func getDni() -> String {
        return UserDefaults.standard.string(forKey: KEY_DNI)!
    }
    
    func saveAndPutDni(dni:String) {
        UserDefaults.standard.set(dni,forKey: KEY_DNI)
        UserDefaults.standard.synchronize()
    }
        
    func deleteDni() {
        UserDefaults.standard.removeObject(forKey: KEY_DNI)
        UserDefaults.standard.synchronize()
    }
    
    func getDateBirthDate() -> String {
        return UserDefaults.standard.string(forKey: KEY_DATE_BIRTHDATE)!
    }
    
    func saveAndPutDateBirthDate(dni:String) {
        UserDefaults.standard.set(dni,forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.synchronize()
    }
        
    func deleteDateBirthDate() {
        UserDefaults.standard.removeObject(forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.synchronize()
    }
    
    func getAddress() -> String {
        return UserDefaults.standard.string(forKey: KEY_ADDRESS)!
    }
    
    func saveAndPutAddress(dni:String) {
        UserDefaults.standard.set(dni,forKey: KEY_ADDRESS)
        UserDefaults.standard.synchronize()
    }
        
    func deleteAddress() {
        UserDefaults.standard.removeObject(forKey: KEY_ADDRESS)
        UserDefaults.standard.synchronize()
    }
    
    func getEmail() -> String {
        return UserDefaults.standard.string(forKey: KEY_EMAIL)!
    }
    
    func saveAndPutEmail(dni:String) {
        UserDefaults.standard.set(dni,forKey: KEY_EMAIL)
        UserDefaults.standard.synchronize()
    }
        
    func deleteEmail() {
        UserDefaults.standard.removeObject(forKey: KEY_EMAIL)
        UserDefaults.standard.synchronize()
    }
    
    func clearUsersDefault(){
        UserDefaults.standard.removeObject(forKey: KEY_DNI)
        UserDefaults.standard.removeObject(forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.removeObject(forKey: KEY_ADDRESS)
        UserDefaults.standard.removeObject(forKey: KEY_EMAIL)
        UserDefaults.standard.synchronize()
    }
    
}
