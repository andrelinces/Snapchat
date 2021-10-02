//
//  UsuariosTableViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 29/09/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var usuarios: [ Usuario ] = []
    var urlImage = ""
    var descricao = ""
    var idImagem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //teste do stackoverflow, recuperar dados do usuário no firebase
        
        Database
            .database()
                .reference()
                .child("usuarios")
                .child(Auth.auth().currentUser!.uid)
                //.child("Advertisements")
                .queryOrderedByKey()
                .observeSingleEvent(of: .value, with: { snapshot in

                    guard let dict = snapshot.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    let imageAd = dict["imageAd"] as? String
                    //let priceAd = dict["priceAd"] as? String
                    print(imageAd)
                    
                })
        */
        
        //recuperar os dados do firebase
        let RecuperaDataBase = Database.database().reference()
        let usuarios = RecuperaDataBase.child("usuarios")
        
        //Adiciona evento, novo usuário adicionado, listener, observador!!
        usuarios.observe(DataEventType.childAdded) { snapshot in
            
            //print para testar o snapshot
            //print(snapshot)
            
            
            let dados = snapshot.value as? NSDictionary
            
            //recuperar dados
            let emailUsuario = dados?["email"] as! String
            let nomeUsuario = dados?["nome"] as! String
            let uidUsuario = snapshot.key
            
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: uidUsuario)
            
            self.usuarios.append(usuario)
            //Reload para recarregar a table view depois de recuperar o array do firebase
            self.tableView.reloadData()
            print( self.usuarios)
         
        }
        
        
    }
    //número de sessões da table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //quantidade de linhas da table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.usuarios.count
    }
    
    //montar célula
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        //configurar celula
        let usuario = self.usuarios [ indexPath.row ]
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        return celula
        
    }
    
    //método para tratar quando uma célula é selecionada.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let usuarioSelecionado = self.usuarios [ indexPath.row ]
        //print para testar se o método está selecionando corretamente o nome do usuário
        //print(usuarioSelecionado.nome)
        let idUsuarioSelecionado = usuarioSelecionado.uid
        
        //criando referéncia com o banco de dados.
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        //Criando os 'nós' do banco de dados que vai identificar para qual usuário será envia o snap. Primeiro nó : snap
        let snaps = usuarios.child( idUsuarioSelecionado ).child("snaps")
        
        //recuperar dados do usuário logado que enviou o snap
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
        
            let usuarioLogado = usuarios.child(idUsuarioLogado)
            usuarioLogado.observeSingleEvent(of: DataEventType.value) { snapshot in
                //print para testar e exibir email e nome de quem esta logado. (enviando o snap)
                //print(snapshot)
                
                //recuperando os dados do snapshot
                let dados = snapshot.value as? NSDictionary
                  
                let snap = [
                
                    "de": dados?["email"] as! String,
                    "nome": dados?["nome"] as! String,
                    "descricao": self.descricao,
                    "urlImagem": self.urlImage,
                    "idImagem": self.idImagem
                    
                ]
                
                //criando segundo nó: id único do snap enviado para o usuário.
                snaps.childByAutoId().setValue(snap)
                
                //Redireciona o usuário após enviar um snap para a tela de snaps recebidos
                
            }
        }//fim do if idUsuarioLogado
          
    }
    
    
}
