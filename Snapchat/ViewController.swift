//
//  ViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 20/09/21.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //teste de deslogar para verificar se o método verificar e redirecionar o usuário já logado está funcionando.
        /*
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
        } catch  {
            print("Erro ao deslogar o usuário!")
        }
        */
        //Autenticação automatica quando o usuário já esta logado.
        let autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { autenticacao, usuario in
            
            if let usuarioLogado = usuario {
                
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
            
        }
          
    }
    //Oculta barra de navegação
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

}

