//
//  AnswerViewController.swift
//  firstAid
//
//  Created by heoju on 2017. 6. 7..
//  Copyright © 2017년 HJ. All rights reserved.
//  https://github.com/hyperoslo/ImagePicker

import UIKit
import ImagePicker
import GTZoomableImageView
import TZZoomImageManager

class AnswerViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, ImagePickerDelegate, UITextViewDelegate, UIScrollViewDelegate {

    var selectedQuestionPage:QuestionPage!
    var table:UITableView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var chosenImages: [UIImage] = []
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func CancelDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneDIsmiss(_ sender: Any) {
        
        let text = textView.text
        let image = chosenImages
        
        let answerPage = AnswerPage(text: text!)
        answerPage.image = image
        
        selectedQuestionPage.addAnswer(answerPage)
        
/*
        //Something to do
        //class Questions send json request
        let title = titleText.text
        let text = textView.text
        let images = chosenImages
        let number = Int(numberText.text!)
        
        
        let questionDetail = QuestionPage(number: number!, title: title!, tag: "", text: text!)
        questionDetail.image = images
        
        // 같은 번호의 문제를 받았을 경우, 한개 번호에 다 넣어줌.
        var find:Bool = false
        for i in selectedBook.bookQuestion{
            if(i.questionNumber == number){
                i.addPage(questionDetail)
                find = true
            }
        }
        if(!find){
            let q = Question(book: selectedBook, chapter: 1, number: number!, tag: "", answer: 1)
            q.addPage(questionDetail)
            selectedBook.addQuestion(q)
        }
        /*
         let q = Question(book: selectedBook, chapter: 1, number: number!, tag: "", answer: 1)
         q.addPage(questionDetail)
         selectedBook.addQuestion(q)
         */
 */
 
        table.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        //self.dismiss(animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        //var chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        if !chosenImages.isEmpty {
            for v in imageScrollView.subviews {
                v.removeFromSuperview()
            }
        }
        
        chosenImages = images
        //let imagePickerController = ImagePickerController()
        
        
        for i in 0 ..< chosenImages.count{
            let imageView = UIImageView()
            imageView.image = chosenImages[i]
            let xPosition = self.view.frame.width  * CGFloat(i) * CGFloat(0.5)
            //print(self.imageScrollView.frame.height)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.imageScrollView.frame.width * CGFloat(0.5), height: self.imageScrollView.frame.height)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gestureRecognizer:)))
            imageView.addGestureRecognizer(tapRecognizer)
            imageView.isUserInteractionEnabled = true
            
            //imageView.addGestureRecognizer(tapRecognizer)
            
            
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(0.5) * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
        }
        
        //viewsection.contentMode = .scaleAspectFit
        //viewsection.image = chosenImages[0]
        //viewsection.image =
        
        self.dismiss(animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
  func imageTapped(gestureRecognizer: UITapGestureRecognizer){
    //tappedImageView is tapped image
    let tappedImageView = gestureRecognizer.view! as! UIImageView
    let storyboard = UIStoryboard(name:
      "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "ImageZoomNavigationViewController")
    let tmp = controller as! ImageZoomNavigationViewController
    tmp.tappedImage = tappedImageView.image
    
    self.present(tmp, animated: true, completion: nil)
  }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        //self.dismiss(animated: true, completion: nil)
    }
    
    func navigationBarTap(_ recognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.delegate = self
        textView.text = placeHolder
        textView.textColor = UIColor.lightGray
        
        //textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.navigationBarTap))
        hideKeyboard.numberOfTapsRequired = 1
        navigationController?.navigationBar.addGestureRecognizer(hideKeyboard)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text as NSString?
        let updateText = currentText?.replacingCharacters(in: range, with: text)
        
        if (updateText?.isEmpty)! {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty{
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
    //
    //  func textViewDidChangeSelection(_ textView: UITextView) {
    //    if self.view.window != nil {
    //      if textView.textColor == UIColor.lightGray {
    //        //textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    //      }
    //    }
    //  }
    //
    
    @IBAction func photoFromLibrary(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
