//
//  ViewController.swift
//  Project27.5
//
//  Created by Connor Lee on 02/08/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var currentImage: UIImage!
    var topText = ""
    var botText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [add, share]
        let top = UIBarButtonItem(title: "Top", style: .plain, target: self, action: #selector(addTopText))
        let bottom = UIBarButtonItem(title: "Bottom", style: .plain, target: self, action: #selector(addBotText))
        navigationItem.leftBarButtonItems = [top, bottom]
    }
    
    func drawImagesAndText() {
        // Render their image plus both pieces of text into one finished UIImage using Core Graphics.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let image = renderer.image { ctx in
            
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.systemYellow,
                .backgroundColor: UIColor.black,
                //.strokeColor: UIColor.systemYellow,
                //.strokeWidth: 5
            ]

            let topString = NSAttributedString(string: topText, attributes: attrs)
            let botString = NSAttributedString(string: botText, attributes: attrs)

            topString.draw(with: CGRect(x: 0, y: 0, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            botString.draw(with: CGRect(x: 0, y: 450, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
        }

        imageView.image = image
    }
    
    @objc func shareTapped() {
        // sharing image data
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("no image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        
        // required for ipad
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        currentImage = image
        
        drawImagesAndText()
        
        dismiss(animated: true)
    }

    @objc func addTopText() {
        textInput(isBotText: false)
    }
    
    @objc func addBotText() {
        textInput(isBotText: true)
    }
    
    func textInput(isBotText: Bool) {
        let ac = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer, isBotText: isBotText)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String, isBotText: Bool) {
        if isBotText {
            botText = answer
        } else {
            topText = answer
        }
        
        drawImagesAndText()
    }
    
}

