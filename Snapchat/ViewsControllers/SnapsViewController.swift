//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 23/09/21.
//

import UIKit
import FirebaseAuth

class SnapsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
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
        
    }
    
      
    
}
