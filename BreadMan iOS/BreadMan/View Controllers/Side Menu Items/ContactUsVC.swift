//
//  ContactUsVC.swift
//  BreadMan
//
//  Created by apple on 04/06/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    // Outlets
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var txtSubject: AppTextField!
    @IBOutlet weak var txtMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtMessage.text = ""
        self.txtMessage.text = "Description"
        self.txtMessage.textColor = UIColor.lightText
    }
    
    // Button Actions
    @IBAction func clickedSend(_ sender: Any) {
        
        if self.txtSubject.isEmpty() {
            self.showAlert(msg: "Enter subject")
            return
        }
        if self.txtMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" || self.txtMessage.textColor == UIColor.lightText {
            self.showAlert(msg: "Enter description")
            return
        }
        
        // Send Mail
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showAlert(msg: "Your device could not send e-mail. Please check e-mail configuration and try again.")
        }
    }
    
    // Send Mail Action
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("\(self.txtSubject.text ?? "")")
        mailComposerVC.setMessageBody("\(self.txtMessage.text ?? "")", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.showAlert(msg: "Your device could not send e-mail. Please check e-mail configuration and try again.")
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ContactUsVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightText {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
       
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightText
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 251
    }
    
}
