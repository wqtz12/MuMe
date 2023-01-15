//
//  DetailViewController.swift
//  MuMe
//
//  Created by HIFI on 2021/03/07.
//

import UIKit
import PhotosUI

class DetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imgMume: UIImageView!
    @IBOutlet weak var artistMume: UILabel!
    @IBOutlet weak var songMume: UILabel!
    @IBOutlet weak var diaryMume: UITextView!
    @IBOutlet weak var sendMume: UIButton!
    
    let picker = UIImagePickerController()
    let alert = UIAlertController(title: "사진선택", message: "원하는 사진을 선택해주세요", preferredStyle: .actionSheet)

    var searchImg: String = ""
    var searchAtrist: String = ""
    var searchSong: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchMusic" {
            
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (searchAtrist.isEmpty){
            artistMume.text = "음악을 선택해주세요"
            songMume.text = searchSong
            sendMume.isHidden = true
            
        } else {
            artistMume.text = searchAtrist
            songMume.text = searchSong
            
        }


        // Do any additional setup after loading the view.
        // UIImagePickerControllerDelegate를 현재 DetailViewController에게 부여한다.
        picker.delegate = self
        
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let photo = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openPhoto()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(photo)
        alert.addAction(cancel)
        
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(takeAction(gestuerRecongnizer:)))
        let tabGesture2 = UITapGestureRecognizer(target: self, action: #selector(takeAction(gestuerRecongnizer:)))
        let tabGesture3 = UITapGestureRecognizer(target: self, action: #selector(takeAction(gestuerRecongnizer:)))
        imgMume.addGestureRecognizer(tabGesture)
        imgMume.isUserInteractionEnabled = true
        artistMume.addGestureRecognizer(tabGesture2)
        artistMume.isUserInteractionEnabled = true
        songMume.addGestureRecognizer(tabGesture3)
        songMume.isUserInteractionEnabled = true

        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(dismissFunc), name: UIApplication.willResignActiveNotification, object: nil)
            
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgMume.image = image
        }
        dismiss(animated: true  , completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func takeAction(gestuerRecongnizer: UIGestureRecognizer) {
        

                
        print("gestuerRecongnizer : ")
        

        

        //print("gestuerRecongnizer : \(gestuerRecongnizer.location(in: gestuerRecongnizer.view))")
        
        guard let singerID = gestuerRecongnizer.view?.restorationIdentifier  else {
           return
        }
        print("ID : \(singerID)")
        
        if singerID == "Singer" || singerID == "Song" {
            performSegue(withIdentifier: "SearchMusic", sender: nil)
        } else {
            
            present(alert, animated: true, completion: nil)
        }
        
        
       
    }

    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
       
    }
    
    func openPhoto() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            print("Don't use the camara")
        }

    }
    @objc func dismissFunc(){

          self.alert.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func send(_ sender: Any) {
        
    }
    
    
}
protocol MasterSendData {
    func masterSendData(data: diary)
}

struct diary {
    var imgMume: UIImageView!
    var artistMume: UILabel!
    var songMume: UILabel!
    var diaryMume: UITextView!    
}

extension DetailViewController: DetailSendData {
    func detailSendData(data: music) {
        
        artistMume.text = data.artist
        songMume.text = data.title
        sendMume.isHidden = false
        
        
        placeholderSetting()
        
        
        
        //texview
        
        //라인간 행간을 준 것이지만 다 만들어지 텍스트 간의 행간이지 텍스트를 작성 중의 행간은 아닌 듯 함
        let lineSpaceAmount = NSMutableParagraphStyle()
        var attributetext = self.diaryMume.attributedText
        guard let contentText = self.diaryMume.text else {
            return
        }
        lineSpaceAmount.lineSpacing = 5
        
        attributetext = NSAttributedString(string: contentText as String, attributes: [NSAttributedString.Key.paragraphStyle:lineSpaceAmount])
    }
}


extension DetailViewController: UITextViewDelegate {
    
    func placeholderSetting() {
        diaryMume.delegate = self
        //textview 라인 그려주기
        self.diaryMume.layer.borderWidth = 1.0
        self.diaryMume.layer.borderColor = UIColor.black.cgColor
        self.diaryMume.layer.cornerRadius = 10
        //textview placeholder
        diaryMume.text = "노래에 대한 그대의 이야기를 들려주세요.."
        diaryMume.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            //textview 라인 그려주기
            self.diaryMume.layer.borderWidth = 1.0
            self.diaryMume.layer.borderColor = UIColor.black.cgColor
            //textview placeholder
            textView.text = "노래에 대한 그대의 이야기를 들려주세요.."
            textView.textColor = UIColor.lightGray
        }
    }
    
}







