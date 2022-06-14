//
//  SedeResponse.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/12/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import Foundation

struct ApiResponseSede{
    var data:[Campus]
    var status:String
}

struct Campus{
    var idSede:Int
    var nombre:String
}
