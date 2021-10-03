//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 02/10/21.
//

import UIKit
import SDWebImage

class DetalhesSnapViewController: UIViewController {
    
    @IBOutlet weak var imagemSnap: UIImageView!
    
    @IBOutlet weak var descricaoSnap: UILabel!
    
    @IBOutlet weak var contadorSnap: UILabel!
    
    //criando referência da classe Snaps para o objeto snap.
    var snap = Snaps()
    
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
            }
            
        }
        
    }
    //Método utilizado para tratar quando o usuário fechar uma view, será utilizado para ao fechar a view excluir o snap.
    override func viewDidDisappear(_ animated: Bool) {
        
        //print para testar o método
        print("view foi fechada!")
    }
    
}
