//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 02/10/21.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DetalhesSnapViewController: UIViewController {
    
    @IBOutlet weak var imagemSnap: UIImageView!
    
    @IBOutlet weak var descricaoSnap: UILabel!
    
    @IBOutlet weak var contadorSnap: UILabel!
    
    //criando referência da classe Snaps para o objeto snap.
    var snap = Snaps()
    //variável para marcar o tempo do contador
    var tempo = 11
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print para testar se a classe Detalhesviewcontroller está recuperando e enviando corretamente os detalhes do snap para a view detalhesSnap
        //print(snap.descricao)
        
        //Utilizando o ipo SDwebImage, baixando a url da foto
        descricaoSnap.text = snap.descricao
        
        let url = URL(string: snap.urlImagem)
        imagemSnap.sd_setImage(with: url) { imagemSnap, erro, cache, url in
            
            if erro == nil {
            //print para testar e exibir a imagem
            //print("imagem exibida")
                
                //Utilizando a classe timer para criar o contador.
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    
                    //print para testar o método Timer
                    //print("Timer executando...")
                    
                    //decrementar o tempo do contador da view detalhes
                    self.tempo = self.tempo - 1
                    //Exibe o timer na tela
                    self.contadorSnap.text = String(self.tempo)
                    
                    //Caso o timer execute até o zero, invalida
                    if self.tempo == 0 {
                        //Método invalidate, vai parar o timer quando chegar no zero.
                        timer.invalidate()
                        //Método dismiss, fechar a view quando o contador chegar no zero.
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                }
            }
            
        }
        
    }
    //Método utilizado para tratar quando o usuário fechar uma view, será utilizado para ao fechar a view excluir o snap.
    override func viewDidDisappear(_ animated: Bool) {
        //print para testar o método
        //print("view foi fechada!")
        
        //criando referência para a objeto autenticacao
        let autenticacao = Auth.auth()
        //recuperando o id do usuário logado
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            
            //criando referência do objeto com o firebase para remover os snaps
            let database = Database.database().reference()
            //acessando o nó usuarios
            let usuarios = database.child("usuarios")
            //acessando o nó snaps
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            //removendo o nó snap selecionado
            snaps.child(snap.identificador).removeValue()
            
            //removendo a imagem snap do storage, criando a referência do objeto com o storage.
            let storage = Storage.storage().reference()
            //criando referência do objeto com o storage
            let imagens = storage.child("imagens")
            
            
            //acessando a pasta imagens do storage, e deletando o snap
            imagens.child("\(snap.idImagem).jpg").delete { erro in
                
                if erro == nil {
                    //Atualizando a table view após excluir o snap.
                    
                    print("Sucesso ao excluir a imagem!")
                    
                }else{
                    
                    print("Erro ao excluir a imagem!")
                    
                }
                
            }
            
            
        }//fim do if idUsuarioLogado
        
        
    }//fim do método viewDidDisapear
    
}
