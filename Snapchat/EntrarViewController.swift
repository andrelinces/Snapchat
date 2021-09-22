//
//  EntrarViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 21/09/21.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func entrar(_ sender: Any) {
        //recuperar dados digitados
        if let emailRecuperado = self.email.text{
            
            if let senhaRecuperada = self.senha.text{
     
                //Autenticar usuário no firebase
                let autenticacao = Auth.auth()
                autenticacao.signIn(withEmail: emailRecuperado, password: senhaRecuperada) { usuario, erro in
                    
                    if erro == nil {
                        
                        if usuario == nil {
                            
                            self.exibirMensagem(titulo: "Erro de autenticação", mensagem: "Erro ao autenticar o usuário, tente novamente")
                        
                    }else{
                        
                        //self.exibirMensagem(titulo: "Sucesso !!", mensagem: "Usuário logado com sucesso !")
                        //Redireciona o usuário para a tela principal
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        
                    }
                    }else{
                        
                        self.exibirMensagem(titulo: "Dados incorretos", mensagem: "Verifique os dados digitados e tente novamente")
                    }
                    
                }
                
                
            }
        }
    }
    //Método para exibir mensagens em caso de erro ao logar.
    func exibirMensagem (titulo: String, mensagem: String  ){
        
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(acaoCancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Oculta barra de navegação
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
       
}
