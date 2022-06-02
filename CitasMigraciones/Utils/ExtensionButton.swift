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
    }}
