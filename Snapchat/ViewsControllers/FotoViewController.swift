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
    var idImagem = NSUUID().uuidString
    
    
    @IBAction func proximoPasso(_ sender: Any) {
        /*
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
            imagens.child("\(idImagem).jpg").putData(imagemDados, metadata: nil) { metaDados, erro in
               
                //Caso não ocorra nenhum erro, vai exibir sucesso do print
                if erro == nil {
                    //print para testar o método
                    print("Sucesso ao fazer upload do arquivo!")
                    
                    self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: nil )
                    
                    
                    //recuperando a url da imagem selecionada.
                    /*
                    imagens.downloadURL { url, erro in
                     
                        if erro == nil {
                            
                            if let downloadUrl = url {
                                
                                let donwloadString = downloadUrl.absoluteString
                                print( url?.absoluteString )
                                self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: donwloadString )
                            }
                        }
                        
                    }
                    
                    
                    /*
                    imagens.downloadURL(completion: { (url, error) in
                    if error == nil {
                    if let downloadUrl = url {
                    let downloadString = downloadUrl.absoluteString
                    print("\(downloadString)")
                    */
                    
                    //enviando usuário para selecionar para quem vai enviar o snap
                    
                     *///fim da tentativa de recuperação da URL.
                    //Habilitando o botão após salvar a imagem e alterando o texto.
                    self.botaoProximo.isEnabled = true
                    self.botaoProximo.setTitle("Próximo", for: .normal)
                     
                
                }else{
                    
                    print("Erro ao fazer upload do Arquivo")
                    
                    //Exibindo alerta em caso de erro
                    let alerta = Alerta(titulo: "Erro ao salvar a imagem!",
                                        mensagem: "Não foi possível salvar a imagem selecionada, tente novamente")
                    self.present(alerta.getAlerta(), animated: true, completion: nil)
                }
                
            }
          }
            
        }//fim do if imagem selecionada
        
      */
        
        //teste código do fórum
        
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("Carregando...", for: .normal)
         
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
         
        guard let imagemSelecionada = image.image else { return }
        guard let imageData = imagemSelecionada.jpegData(compressionQuality: 0.5) else { return }
         
        let imageReference = imagens.child("\(idImagem).jpg")
         
        imageReference.putData(imageData, metadata: nil) { (metaData, error) in
        if error == nil {
        print("Sucesso")
        self.botaoProximo.isEnabled = true
        self.botaoProximo.setTitle("Feito!", for: .normal)
        self.botaoProximo.isEnabled = false
         
        imageReference.downloadURL(completion: { (url, error) in
        if error == nil {
        if let downloadUrl = url {
        let downloadString = downloadUrl.absoluteString
        print("\(downloadString)")
        self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: downloadString)
        }
        } else {
        print("\(error!) Nada capturado")
        }
        })
         
        } else {
        let alerta = Alerta(titulo: "Ocorreu um erro inespero", mensagem: "Erro ao processar o Snap")
        self.present(alerta.getAlerta(), animated: true, completion: nil)
        }
        }
           
    }//fim do método próximo passo
    
    //Método criado para passar as informações do snap já recuperado para a classe UsuariosTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selecionarUsuarioSegue" {
            
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImage = sender as! String
            usuarioViewController.idImagem = self.idImagem
            
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
