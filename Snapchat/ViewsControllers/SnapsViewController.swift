//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 23/09/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snaps] = []
    
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
            snaps.observe( DataEventType.childAdded) { snapshot in
                //print para testar a exibição no log
                //print(snapshot)
                
                let dados = snapshot.value as? NSDictionary
                
                //criando referencia do objeto com a classe Snaps
                let snap = Snaps()
                
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
                
                //Montando a quantidade de snaps recebidos
                self.snaps.append( snap )
                //recarregando a tabela
                self.tableView.reloadData()
                //print para testar se o objeto snap está recebendo todos os dados recuperados do snap.
                print(self.snaps)
                
            }
            
            
        }//fim do if idUsuarioLogado
        
        
    }
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    */
    //Quantidade de snaps por linha
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = self.snaps.count
        if totalSnaps == 0 {
            return 1
        }
        
        //Retornar a quantidade de linhas necessárias de acordo com a quantidade de snaps
        return totalSnaps
    }
    //Montando a celula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        let totalSnaps = snaps.count
        
        if totalSnaps == 0 {
            
            //Caso não tenha nenhum snap, será exibida mensagem na célula.
            celula.textLabel?.text = "Nenhum snap para voce :-)"
        }else{
            //Caso tenha o snap será montado os snaps na tela.
            let snap = self.snaps[ indexPath.row ]
            celula.textLabel?.text = snap.nome
            
        }
        
        return celula
        
    }
    
}
