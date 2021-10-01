//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 21/09/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var nomeCompleto: UITextField!
    
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
            
            if let nomeCompletoR = self.nomeCompleto.text{
                
                if let senhaRecuperada = self.senha.text{
                    
                    if let confirmarSenhaR = self.confirmarSenha.text{
                        
                        //validar senha
                            if senhaRecuperada == confirmarSenhaR {
                                
                                //validar nome Completo
                                if nomeCompletoR != "" {
                                    
                                    
                                //Criar conta firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailRecuperado, password: senhaRecuperada) { usuario, erro in
                                    
                                    if erro == nil {
                                        
                                        
                                        if usuario == nil {
                                            
                                            self.exibirMensagem(titulo: "Erro de autenticação", mensagem: "Erro ao autenticar o usuário, tente novamente")
                                            
                                        }else{
                                            
                                            //salvando o snap no banco de dados, criando referência do banco.
                                            let dataBase = Database.database().reference()
                                            //criando nó dos usuários
                                            let usuarios = dataBase.child("usuarios")
                                            
                                            let usuarioDados = [ "nome": nomeCompletoR, "email": emailRecuperado ]
                                            usuarios.child( usuario!.user.uid ).setValue( usuarioDados )
                                            
                                            print("Sucesso ao cadastrar o usuário")
                                            //Redireciona o usuário para a tela principal
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                            
                                        }
                                        
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
                                
                                }else{
                                    
                                    //Exibindo alerta em caso de erro
                                    let alerta = Alerta(titulo: "Erro ao salvar a imagem!",
                                                        mensagem: "Não foi possível salvar a imagem selecionada, tente novamente")
                                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                                    
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
        
    }//Fechamento do método criar conta
    
    //Oculta barra de navegação
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    
    
}
