//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 23/09/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController {
    
    @IBAction func sair(_ sender: Any) {
        
        let autenticacao = Auth.auth()
        
        do {
            
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
            //teste para quando o usuário deslogar sair da snaps e ir para tela entrar
            //elf.performSegue(withIdentifier: "sairSegue", sender: nil)
            print("Usuário deslogado com sucesso!!")
        } catch  {
            print("Erro ao deslogar o usuário!")
        }
        
    }//Fim do método sair.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Criando referência de autenticação
        let autenticacao = Auth.auth()
        
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            //Criando referência com o firebase para acessar os dados do salvos do usuário logado
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            
            let snaps = usuarios.child( idUsuarioLogado ).child("snaps") 
            
            //cria ouvinte para o Snaps
            
            
        }
        
        
    }
    
      
    
}
