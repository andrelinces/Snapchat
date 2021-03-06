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
                                            
                                            self.exibirMensagem(titulo: "Erro de autentica????o", mensagem: "Erro ao autenticar o usu??rio, tente novamente")
                                            
                                        }else{
                                            
                                            //salvando o snap no banco de dados, criando refer??ncia do banco.
                                            let dataBase = Database.database().reference()
                                            //criando n?? dos usu??rios
                                            let usuarios = dataBase.child("usuarios")
                                            
                                            let usuarioDados = [ "nome": nomeCompletoR, "email": emailRecuperado ]
                                            usuarios.child( usuario!.user.uid ).setValue( usuarioDados )
                                            
                                            print("Sucesso ao cadastrar o usu??rio")
                                            //Redireciona o usu??rio para a tela principal
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                            
                                        }
                                        
                                    }else{
                                        //print para testar mensagem em caso de falha ao cadastrar usu??rio
                                        //print("Erro ao cadastrar o usu??rio")
                                        
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
                                                mensagemErro = "E-mail inv??lido, digite um email v??lido"
                                                break
                                                
                                            case "ERROR_WEAK_PASSWORD" :
                                                mensagemErro = "A Senha precisa ter no m??nimo 6 caracteres, incluindo letras e n??meros!"
                                                
                                            case "ERROR_WEAK_PASSWORD" :
                                                mensagemErro = "Este e-mail j?? est?? sendo utilizado, utilize outro e-mail!"
                                            default:
                                                mensagemErro = "Os dados digitados est??o incorretos!"
                                            }
                                            
                                            self.exibirMensagem(titulo: "Dados inv??lidos", mensagem: mensagemErro)
                                            
                                        }
                                    }//fim validacao erro firebase
                                    
                                    }
                                
                                }else{
                                    
                                    //Exibindo alerta em caso de erro
                                    let alerta = Alerta(titulo: "Erro ao salvar a imagem!",
                                                        mensagem: "N??o foi poss??vel salvar a imagem selecionada, tente novamente")
                                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                                    
                                }
                                
                                //Print para testar a fun????o
                                //print("Senhas iguais, podemos prosseguir")
                            }else{
                                
                                self.exibirMensagem(titulo: "Senha Incorreta!", mensagem: "As senhas digitadas n??o s??o iguais, digite a mesma senha nos 2 campos")
                                
                            }//Fim do if validar senha
                          
                    }
                }
                
            }
        }
        
    }//Fechamento do m??todo criar conta
    
    //Oculta barra de navega????o
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    
    
}
