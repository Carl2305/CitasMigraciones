//
//  UsersDefaultsCitasMigraciones.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

class UsersDefaultsCitasMigraciones{
    private let KEY_LOGIN="MY_KEY_LOGIN"
    private let KEY_DNI="MY_KEY_DNI"
    private let KEY_DATE_BIRTHDATE="MY_KEY_DATE_BIRTHDATE"
    private let KEY_ADDRESS="MY_KEY_ADDRESS"
    private let KEY_EMAIL="MY_KEY_EMAIL"
    private let KEY_NAME_USER="MY_KEY_NAME_USER"
    private let KEY_LAST_NAME_USER="MY_KEY_LAST_NAME_USER"
    
    func getIsLogued() -> Bool{
        return UserDefaults.standard.bool(forKey: KEY_LOGIN)
    }
    
    func saveIsLogued(signIn:Bool) {
        UserDefaults.standard.set(signIn,forKey: KEY_LOGIN)
        UserDefaults.standard.synchronize()
    }
    
    func getDni() -> String {
        return UserDefaults.standard.string(forKey: KEY_DNI) ?? ""
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
        return UserDefaults.standard.string(forKey: KEY_DATE_BIRTHDATE) ?? ""
    }
    
    func saveAndPutDateBirthDate(date:String) {
        UserDefaults.standard.set(date,forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.synchronize()
    }
        
    func deleteDateBirthDate() {
        UserDefaults.standard.removeObject(forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.synchronize()
    }
    
    func getAddress() -> String {
        return UserDefaults.standard.string(forKey: KEY_ADDRESS) ?? ""
    }
    
    func saveAndPutAddress(address:String) {
        UserDefaults.standard.set(address,forKey: KEY_ADDRESS)
        UserDefaults.standard.synchronize()
    }
        
    func deleteAddress() {
        UserDefaults.standard.removeObject(forKey: KEY_ADDRESS)
        UserDefaults.standard.synchronize()
    }
    
    func getEmail() -> String {
        return UserDefaults.standard.string(forKey: KEY_EMAIL) ?? ""
    }
    
    func saveAndPutEmail(email:String) {
        UserDefaults.standard.set(email,forKey: KEY_EMAIL)
        UserDefaults.standard.synchronize()
    }
        
    func deleteEmail() {
        UserDefaults.standard.removeObject(forKey: KEY_EMAIL)
        UserDefaults.standard.synchronize()
    }
    
    func getName() -> String {
        return UserDefaults.standard.string(forKey: KEY_NAME_USER) ?? ""
    }
    
    func saveAndPutName(name:String) {
        UserDefaults.standard.set(name,forKey: KEY_NAME_USER)
        UserDefaults.standard.synchronize()
    }
        
    func deleteName() {
        UserDefaults.standard.removeObject(forKey: KEY_NAME_USER)
        UserDefaults.standard.synchronize()
    }
    
    func getLastName() -> String {
        return UserDefaults.standard.string(forKey: KEY_LAST_NAME_USER) ?? ""
    }
    
    func saveAndPutLastName(last:String) {
        UserDefaults.standard.set(last,forKey: KEY_LAST_NAME_USER)
        UserDefaults.standard.synchronize()
    }
        
    func deleteLastName() {
        UserDefaults.standard.removeObject(forKey: KEY_LAST_NAME_USER)
        UserDefaults.standard.synchronize()
    }
    
    func clearUsersDefault(){
        UserDefaults.standard.removeObject(forKey: KEY_LOGIN)
        UserDefaults.standard.removeObject(forKey: KEY_DNI)
        UserDefaults.standard.removeObject(forKey: KEY_DATE_BIRTHDATE)
        UserDefaults.standard.removeObject(forKey: KEY_ADDRESS)
        UserDefaults.standard.removeObject(forKey: KEY_EMAIL)
        UserDefaults.standard.removeObject(forKey: KEY_NAME_USER)
        UserDefaults.standard.removeObject(forKey: KEY_LAST_NAME_USER)
        UserDefaults.standard.synchronize()
    }
    
}
