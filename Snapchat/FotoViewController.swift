//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Andre Linces on 23/09/21.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var descricao: UITextField!
    
    @IBOutlet weak var botaoProximo: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    
    @IBAction func proximoPasso(_ sender: Any) {
        //Desabilitando o botão quando pressionado exibindo mensagem enquanto carrega a foto selecionada.
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        //Salvando os dados no firebase, instanciando objeto
        let armazenamento = Storage.storage().reference()
        //Criando pasta para organizar as imagens
        let imagens = armazenamento.child("imagens")
        
        //recuperar a imagem
        if let imagemSelecionada = image.image {
            
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5) {
            imagens.child("imagem.jpg").putData(imagemDados, metadata: nil) { metaDados, erro in
               
                //Caso não ocorra nenhum erro, vai exibir sucesso do print
                if erro == nil {
                    
                    print("Sucesso ao fazer upload do arquivo!")
                    //Habilitando o botão após salvar a imagem e alterando o texto.
                    self.botaoProximo.isEnabled = true
                    self.botaoProximo.setTitle("Próximo", for: .normal)
                    
                }else{
                    
                    print("Erro ao fazer upload do Arquivo")
                    
                }
                
            }
          }
            
        }
        
        
        
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil )
        
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print para testar se esta selecionando a foto corretamente.
        //print(info)
        
        //Utilizando o dicionário (info) para recuperar a foto selecionada pelo usuário.
        let imagemRecuperada = info [ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        //recuperando imagem e exibindo na UIImageView.
        image.image = imagemRecuperada
        
        //habilitar o botão próximo quando o usuário selecionar a foto.
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.686, green: 0.322, blue: 0.871, alpha: 1)
        
        //objeto utilizado para fechar a biblioteca quando o usuário selecionar a foto.
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //Desabilita o botão ao carregar a tela, até que o usuário selecione uma foto.
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray
        
    }
    
}
