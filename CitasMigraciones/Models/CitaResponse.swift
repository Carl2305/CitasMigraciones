//
//  CitaResponse.swift
//  CitasMigraciones
//
//  Created by Carlos Mogollon Espinoza on 6/13/22.
//  Copyright © 2022 Carlos Alberto Mogollon Espinoza. All rights reserved.
//

import Foundation

struct ApiResponseCita{
    var data:[Cita]
    var status:String
}

struct Cita{
    var idCita:Int
    var fechaRegistro:String
    var recibo:Recibo
    var cupo:Cupo
    var cliente:Cliente
}

struct Recibo{
    var id_recibo:Int
    var codigoVoucher:String
    var codigoVerificacion:String
    var fechaPago:String
}

struct Cupo {
    var idCupo:Int
    var sede:Campus
    var fechaCupo:String
    var estado:Bool
}

struct Cliente {
    var nombre:String
    var apePaterno:String
    var apeMaterno: String
    var correo:String
    var password:String
    var direccion:String
    var fechaNac:String
    var dni:String
    
}
