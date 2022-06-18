//
//  ExtensionButton.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/2/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import UIKit

extension UIButton{
    func borderRound(){
        layer.cornerRadius=bounds.height/2
        clipsToBounds=true
    }
    
    func borderGreen(){
        layer.borderWidth=2
        layer.borderColor=#colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    }
    func borderRed(){
        layer.borderWidth=2
        layer.borderColor=#colorLiteral(red: 0.9254901961, green: 0.2352941176, blue: 0.1019607843, alpha: 1)
    }
    func borderCyan(){
        layer.borderWidth=2
        layer.borderColor=#colorLiteral(red: 0.01176470588, green: 0.6078431373, blue: 0.8980392157, alpha: 1)
    }
    func borderDarkBlue(){
        layer.borderWidth=2
        layer.borderColor=#colorLiteral(red: 0.1725490196, green: 0.2196078431, blue: 0.2901960784, alpha: 1)
    }
    func borderOrange(){
        layer.borderWidth=2
        layer.borderColor=#colorLiteral(red: 0.9607843137, green: 0.4862745098, blue: 0, alpha: 1)
    }
    
}
