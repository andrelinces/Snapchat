//
//  Alerta.swift
//  Snapchat
//
//  Created by Andre Linces on 29/09/21.
//

import UIKit


class Alerta {
    
    var titulo: String
    var mensagem: String
    
    init ( titulo: String, mensagem: String ) {
        
        self.titulo = titulo
        self.mensagem = mensagem
        
    }
    
    func getAlerta() -> UIAlertController {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alerta.addAction(acaoCancelar)
        return alerta
        
    }
    
}
