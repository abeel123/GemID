//
//  ViewController.swift
//  GemID
//
//  Created by Abel Ortiz on 7/2/23.
//

import CoreML
import UIKit
import SwiftUI



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //App UI components
    
    //header line
    private let lineView: UIView = {
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: 105, width: 400, height: 2.0)
        
        lineView.backgroundColor = UIColor(named: "ColorRedOrangeDark")
        return lineView
    }()
    
    //app title
    private let header: UILabel = {
        let header = UILabel()
        header.text = "Gem ID"
        header.textColor = UIColor(named: "ColorRedOrangeDark")
        header.font = UIFont(name: "georgia-italic", size: 50)
        return header
    }()
    
    //my name
    private let credits: UILabel = {
        let credits = UILabel()
        credits.text = "By: Abel Ortiz"
        credits.textColor = UIColor(named: "ColorRedOrangeDark")
        credits.font = UIFont(name: "georgia-italic", size: 15)
        return credits
    }()
    
    //image dispaly
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = UIColor(named: "ColorRedOrangeDark")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    //image label
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Tap the icon to upload your gem!"
        label.numberOfLines = 0
        label.textColor = UIColor(named: "ColorRedOrangeDark")
        label.font = UIFont(name: "georgia-bold", size: 30)
        return label
    }()
    
    //load conponents
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(header)
        view.addSubview(lineView)
        view.addSubview(credits)

        view.backgroundColor = UIColor(named: "ColorLightOrange")
        
        //tap gesture initialization for image selection
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    //layout positioning
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top+70, width: view.frame.size.width-40, height: view.frame.size.width-40)
            label.frame = CGRect(x: 20, y: view.safeAreaInsets.top+(view.frame.size.width-40)+50, width: view.frame.size.width-40, height: 150)
            header.frame = CGRect(x: 20, y: -90, width: view.frame.size.width-40, height: view.frame.size.width-60)
            credits.frame = CGRect(x: 280, y: -90, width: view.frame.size.width-40, height: view.frame.size.width-40)
    }
    
    //function exe after image tapped, gives library or camera option
    @objc func didTapImage() {
        let alert = UIAlertController(title: "Choose Image", message: "Take a photo with your camera or upload from your library.", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {(action) in
        }
        let accessLibrary = UIAlertAction(title: "Library", style: .default) {(action) in
            self.openLib()
        }
        let accessCam = UIAlertAction(title: "Take a photo", style: .default) {(action) in
            self.openCam()
        }
        alert.addAction(cancel)
        alert.addAction(accessLibrary)
        alert.addAction(accessCam)
        present(alert, animated: true)
    }
    
    //select image from library
    func openLib(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //select image from camera
    func openCam(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //AI model analysis
    //param = user selected image
    private func analyzeImg (image: UIImage?){
        
        //grab image, resize and covert to CVPixelBuffer
        guard let buffer = image?.resize(size: CGSize(width:299, height:299))?
            .getCVPixelBuffer()
        else{
            return
        }
        
        do{
            ///step 1: set configuation for model (no special modifications)
            ///step 2: initialize AI model with configuation
            ///step 3: pass CVPixelBuffer to AI model to create input for analysis
            ///step 4:  execute model prediction with input as param, retrieve results
            let config = MLModelConfiguration()
            let model = try GemClassifier_100_iter(configuration: config)
            let input = GemClassifier_100_iterInput(image: buffer)
            let output = try model.prediction(input: input)
            
            ///text is label model is most confident in
            ///predicton is model's confidence in prediction
            ///set image label to formatted string with output info
            let text = output.classLabel
            let percent = output.classLabelProbs.max(by:{$0.value < $1.value})
            let prediction = Double(floor(1000*(percent!.value * 100))/1000)
            label.text = "The machine is \(prediction)% confident this is \(text)"
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    //image selection functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else{
            return
        }
        imageView.image = image
        analyzeImg(image: image)
        
    }
    
}

