//
//  ConversationViewController.swift
//  GettingStarted
//
//  Created by Paul Ardeleanu on 20/11/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import UIKit
import NexmoClient

class ConversationViewController: UIViewController {

    var user: User!
    var error: Error?
    var conversation: NXMConversation?
    var events: [NXMEvent]?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputTextFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var conversationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(self.logout))
        inputTextField.delegate = self
        conversationTextView.text = ""
        updateInterface()
        getConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Conversation with \(user.interlocutor.rawValue)"
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func logout() {
        NXMClient.shared.logout()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size {
            inputTextFieldBottomConstraint.constant = kbSize.height + 10
        }
    }

    func updateInterface() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // default interface - loading screen
            self.activityIndicator.startAnimating()
            self.statusLabel.alpha = 1.0
            self.statusLabel.text = "Loading..."
            self.conversationTextView.alpha = 0
            self.inputTextField.alpha = 0
            
            // if error found, show it
            if let error = self.error {
                self.activityIndicator.stopAnimating()
                self.statusLabel.text = error.localizedDescription
                return
            }
            
            // the conversation is being retrieved
            guard self.conversation != nil else {
                self.statusLabel.text = "Loading conversation..."
                return
            }
            
            // the conversation events are being retrieved
            guard let events = self.events else {
                self.statusLabel.text = "Loading events..."
                return
            }
            
            // ready to display events
            self.activityIndicator.stopAnimating()
            self.statusLabel.alpha = 0.0
            self.conversationTextView.alpha = 1
            self.inputTextField.alpha = 1
            
            // no events found
            if events.count == 0 {
                self.conversationTextView.text = "No messages yet"
                return
            }
            
            self.conversationTextView.text = ""
            
            // events found - show them based on their type
            
            
        }
    }
    
    //MARK: Show events
    
    
    
    
    //MARK: Fetch Conversation
    
    func getConversation() {
        
    }
    
    func getEvents() {
        
    }
    
    
    //MARK: Send a message
    
    func send(message: String) {
        inputTextField.resignFirstResponder()
        inputTextField.isEnabled = false
        activityIndicator.startAnimating()
        
    }
}


extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputTextFieldBottomConstraint.constant = 10
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            send(message: text)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
}


//MARK: Conversation Delegate


