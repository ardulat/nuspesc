//
//  ArticleViewController.swift
//  Doner
//
//  Created by MacBook on 13.10.16.
//  Copyright © 2016 Ardulat. All rights reserved.
//

import UIKit
import Firebase
import KFSwiftImageLoader
import SwiftSpinner

protocol PickEventDateDelegate {
    func setPickedEventDate(hasEvent: Bool, date: NSDate)
    func isArticlePassed() -> Bool
    func getPassedArticleDate() -> NSDate
}

class ArticleViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PickEventDateDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isAdmin: Bool = false
    
    let padding: CGFloat = 10.0
    let titleHeight: CGFloat = 40.0
    
    var image: UIImage! = nil
    var imageView: UIImageView! = nil
    var titleView: UITextView! = nil
    var textView: UITextView! = nil
    var subview: UIView! = nil
    
    var saveButton: UIBarButtonItem! = nil
    var addDateButton: UIBarButtonItem! = nil
    
    var currentArticle: Article! = nil
    var articlePassed: Bool = false
    var hasEvent = false
    var eventDate = ""
    
    let storage = FIRStorage.storage().reference()
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkingForAdmin()
        if articlePassed {
            initUI(currentArticle.title, text: currentArticle.text, imageUrl: currentArticle.imageUrl)
        } else {
            initUI("", text: "", imageUrl: "")
        }
        self.updateConstraints()
        ref = FIRDatabase.database().reference()
    }
    
    func checkingForAdmin() {
        isAdmin = NSUserDefaults.standardUserDefaults().boolForKey("admin")
    }
    
    func textViewDidChange(textView: UITextView) {
        updateConstraints()
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 270)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if isAdmin {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.text = nil
                textView.textColor = UIColor.blackColor()
            }
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 270)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if isAdmin {
            if textView.text.isEmpty {
                textView.text = "Type something..."
                textView.textColor = UIColor.lightGrayColor()
            }
            //self.animateTextField(textView, up:false)
            self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func animateTextField(textField: UITextView, up: Bool)
    {
        let movementDistance:CGFloat = -250
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    func initUI(title: String, text: String, imageUrl: String) {
        
        view.addSubview(scrollView)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEventScoreViewController.dismissKeyboard))
        
        self.scrollView.addGestureRecognizer(tap)
        
        let subview = UIView(frame: scrollView.frame)
        let size = self.view.frame.width - 2 * padding
        image = UIImage(named: "enot")
        imageView = UIImageView(image: image)
        imageView.loadImageFromURLString(imageUrl, placeholderImage: UIImage(named: "enot"), completion: nil)
        imageView.frame = CGRect(x: padding, y: padding, width: size, height: size)
        subview.addSubview(imageView)
        
        // adding title view
        titleView = UITextView()
        titleView.delegate = self
        titleView.scrollEnabled = false
        titleView.font = .systemFontOfSize(19)
        titleView.text = title
        titleView.frame = CGRect(x: padding, y: padding + size, width: size, height: titleHeight)
        subview.addSubview(titleView)
        
        titleView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        // adding text view
        textView = UITextView()
        textView.delegate = self
        textView.scrollEnabled = false
        textView.font = .systemFontOfSize(18)
        textView.text = text
        textView.frame = CGRect(x: padding, y: padding + size + titleHeight + padding, width: size, height: 0)
        subview.addSubview(textView)
       
        textView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        scrollView.addSubview(subview)
        
        if !articlePassed {
            titleView.text = "Type a title"
            textView.text = "Type a text"
            titleView.textColor = UIColor.lightGrayColor()
            textView.textColor = UIColor.lightGrayColor()
        }
        
        // adding save bar button item
        
        if isAdmin {
            // making title and text view editable
            textView.editable = true
            titleView.editable = true
            
            // making main image editable
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(ArticleViewController.pickImage))
            imageView.addGestureRecognizer(gesture)
            imageView.userInteractionEnabled = true
            
            // showing save button in nav bar
            saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(ArticleViewController.save))
            addDateButton = UIBarButtonItem(title: "Event Date", style: .Plain, target: self, action: #selector(ArticleViewController.addDateButtonPressed))
            self.navigationItem.setRightBarButtonItems([saveButton, addDateButton], animated: true)
            //self.navigationItem.rightBarButtonItem = saveButton
        } else {
            textView.editable = false
            titleView.editable = false
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateConstraints() {
        // updating title view frame
        let fixedWidth2 = titleView.frame.size.width
        titleView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        let newSize2 = titleView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        var newFrame2 = titleView.frame
        newFrame2.size = CGSize(width: max(newSize2.width, fixedWidth2), height: newSize2.height)
        titleView.frame = newFrame2
        
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: titleView.text)
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(19)], range: NSRange(location: 0, length: titleView.text.characters.count))
        titleView.attributedText = attributedText
        
        // updating text view frame
        textView.frame = CGRect(x: padding, y: padding + imageView.frame.height + titleView.frame.height, width: imageView.frame.height, height: 0)
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: imageView.frame.height + titleView.frame.height + textView.frame.height)
    }
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        dismissKeyboard()
        print("save button pressed")
        
        SwiftSpinner.show("Saving your article")
        
        var newRef = ref.child("articles/")
        var publicationDate = ""
        
        
        if !articlePassed {
            publicationDate = getDateAsString(NSDate())
            newRef = newRef.childByAutoId()
        } else {
            publicationDate = currentArticle.date
            newRef = newRef.child("\(currentArticle.aid)")
        }
        
        let dict: NSDictionary = ["title": titleView.text,
                                  "text": textView.text, "date" : publicationDate,
                                  "hasEvent" : hasEvent, "eventDate" : eventDate]
        
        newRef.setValue(dict)
        
        // Data in memory
        // converting JPEG image to String compressed image
        var data: NSData = NSData()
        if let image = self.imageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)!
        }
        
        // Creating a reference to the upload file
        let riversRef = storage.child("images/\(newRef.key).jpg")
        
        // Deleting the file
        riversRef.deleteWithCompletion { (error) -> Void in
            if (error != nil) {
                let _ = riversRef.putData(data, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print(error)
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata!.downloadURL
                        
                        print(downloadURL)
                    }
                    SwiftSpinner.hide()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                let _ = riversRef.putData(data, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        print(error)
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata!.downloadURL
                        
                        print(downloadURL)
                        self.navigationController?.popViewControllerAnimated(true)
                        SwiftSpinner.hide()
                    }
                }
            }
        }
    }
    
    func addDateButtonPressed() {
        self.performSegueWithIdentifier("SeguePickEventDate", sender: nil)
    }
    
    func setPickedEventDate(hasEvent: Bool, date: NSDate) {
        self.hasEvent = hasEvent
        self.eventDate = getDateAsString(date)
    }
    
    func isArticlePassed() -> Bool {
        if articlePassed {
            return self.currentArticle.hasEvent
        } else {
            return false
        }
    }
    
    func getPassedArticleDate() -> NSDate {
        return gdate(self.currentArticle.eventDate)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SeguePickEventDate" {
            let vc = segue.destinationViewController as! PickEventDateViewController
            vc.delegate = self
        }
    }
    
    func getDateAsString(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        
        var ldh = "", ldm = ""
        if hour < 10 { ldh = "0"}
        if minute < 10 { ldm = "0"}
        
        return "\(day).\(month).\(year), \(ldh)\(hour):\(ldm)\(minute)"
    }
    
}
