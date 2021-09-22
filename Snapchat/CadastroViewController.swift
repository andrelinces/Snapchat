//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 21/09/21.
//

import UIKit
import FirebaseAuth

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    @IBOutlet weak var confirmarSenha: UITextField!
    
    
    func exibirMensagem (titulo: String, mensagem: String  ){
        
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(acaoCancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func criarConta(_ sender: Any) {
        
        if let emailRecuperado = self.email.text{
            
            if let senhaRecuperada = self.senha.text{
                
                if let confirmarSenhaR = self.confirmarSenha.text{
                    
                    //validar senha
                    if senhaRecuperada == confirmarSenhaR {
                        
                        
                        //Criar conta firebase
                        let autenticacao = Auth.auth()
                        autenticacao.createUser(withEmail: emailRecuperado, password: senhaRecuperada) { usuario, erro in
                            
                            if erro == nil {
                                
                                print("Sucesso ao cadastrar o usuário")
                                
                            }else{
                                //print para testar mensagem em caso de falha ao cadastrar usuário
                                //print("Erro ao cadastrar o usuário")
                                
                                //ERROR_INVALID_EMAIL
                                //ERROR_WEAK_PASSWORD
                                //ERROR_EMAIL_ALREADY_IN_USE
                                
                                let erroRecuperado = erro! as NSError
                                //print(erroRecuperado.userInfo["FIRAuthErrorUserInfoNameKey"])
                                if let codigoErro = (erroRecuperado.userInfo["FIRAuthErrorUserInfoNameKey"]){
                                
                                 let erroTexto = codigoErro as! String
                                  var mensagemErro = ""
                                    switch erroTexto {
                                    
                                        case "ERROR_INVALID_EMAIL" :
                                            mensagemErro = "E-mail inválido, digite um email válido"
                                            break
                                            
                                        case "ERROR_WEAK_PASSWORD" :
                                            mensagemErro = "A Senha precisa ter no mínimo 6 caracteres, incluindo letras e números!"
                                          
                                        case "ERROR_WEAK_PASSWORD" :
                                            mensagemErro = "Este e-mail já está sendo utilizado, utilize outro e-mail!"
                                        default:
                                            mensagemErro = "Os dados digitados estão incorretos!"
                                    }
                                
                                    self.exibirMensagem(titulo: "Dados inválidos", mensagem: mensagemErro)
                                    
                                }
                            }//fim validacao erro firebase
                            
                        }
                        
                        //Print para testar a função
                        //print("Senhas iguais, podemos prosseguir")
                    }else{
                        
                        self.exibirMensagem(titulo: "Senha Incorreta!", mensagem: "As senhas digitadas não são iguais, digite a mesma senha nos 2 campos")
                    }//Fim do if validar senha
                    
                }
            }
            
        }
        
        
    }
    
    //Oculta barra de navegação
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    
    
}
