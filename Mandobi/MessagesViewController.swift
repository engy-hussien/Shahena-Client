//
//  MessagesViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/8/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class MessagesViewController: LocalizationOrientedViewController , UITableViewDelegate , UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var imageViewer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        imageView.isHidden = true
        
        messageTxtField.placeholder = LanguageHelper.getStringLocalized(key: "type_msg")
        OrderMapViewController.instance.messageDelegate = self
        
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.estimatedRowHeight = 999
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        OrderMapViewController.instance.messagesDisappeared()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainTabBarController.instance.trip.messages.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MainTabBarController.instance.trip.messages[indexPath.row].type != 0 {
            
            imageView.isHidden = false
            let data: NSData = NSData(base64Encoded: MainTabBarController.instance.trip.messages[indexPath.row].message , options: .ignoreUnknownCharacters)!
            // turn  Decoded String into Data
            let dataImage = UIImage(data: data as Data)
            imageViewer.image = dataImage
//            let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
//            imageViewer.image = cell.clientChatImage.image!


        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell",
                                                 for: indexPath) as! MessageTableViewCell
    
    
        if MainTabBarController.instance.trip.messages[indexPath.row].senderType == "driver" {
            cell.driverMessageTxt.isHidden = true
            cell.driverChatImage.isHidden = true
            if MainTabBarController.instance.trip.messages[indexPath.row].type == 0 {
                cell.clientMessageTxt.text = MainTabBarController.instance.trip.messages[indexPath.row].message
                cell.clientMessageTxt.layer.masksToBounds = true
                cell.clientMessageTxt.layer.cornerRadius = 5
                cell.clientChatImage.isHidden = true
                cell.clientMessageTxt.isHidden = false
            } else {
                let data: NSData = NSData(base64Encoded: MainTabBarController.instance.trip.messages[indexPath.row].message , options: .ignoreUnknownCharacters)!
                // turn  Decoded String into Data
                let dataImage = UIImage(data: data as Data)
                // pass the data image to image View.:)
                cell.clientChatImage.image = dataImage
                cell.clientMessageTxt.isHidden = true
                cell.clientChatImage.isHidden = false
            }
        } else {
            cell.clientMessageTxt.isHidden = true
            cell.clientChatImage.isHidden = true
            if MainTabBarController.instance.trip.messages[indexPath.row].type == 0 {
                cell.driverMessageTxt.text = MainTabBarController.instance.trip.messages[indexPath.row].message
                cell.driverMessageTxt.layer.masksToBounds = true
                cell.driverMessageTxt.layer.cornerRadius = 5
                cell.driverChatImage.isHidden = true
                cell.driverMessageTxt.isHidden = false
            } else {
                let data: NSData = NSData(base64Encoded: MainTabBarController.instance.trip.messages[indexPath.row].message , options: .ignoreUnknownCharacters)!
                // turn  Decoded String into Data
                let dataImage = UIImage(data: data as Data)
                // pass the data image to image View.:)
                cell.driverChatImage.image = dataImage
                cell.driverMessageTxt.isHidden = true
                cell.driverChatImage.isHidden = false
            }
        }
        
        return cell
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(selectedImage, 0)
        let str64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        MainTabBarController.instance.trip.messages.append(Message(senderType: "client",type: 1, message: str64!, time: ""))
        
        SocketIOController.emitEvent(event: SocketEvents.SEND_MESSAGE, withParameters: ["message": str64 as AnyObject,"senderToken":UserDefaults.standard.string(forKey: "connToken") as AnyObject,"receiverToken":MainTabBarController.instance.trip.driverToken as AnyObject,"messageType" : 1 as AnyObject,"senderType": "client" as AnyObject])
        
        messagesTableView.reloadData()

        self.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func sendAction(_ sender: Any) {
        if messageTxtField.text == "" {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "write_msg"), view: self)
        } else {

            SocketIOController.emitEvent(event: SocketEvents.SEND_MESSAGE, withParameters: ["message":messageTxtField.text as AnyObject,"senderToken": UserDefaults.standard.string(forKey: "connToken") as AnyObject,"receiverToken": MainTabBarController.instance.trip.driverToken as AnyObject,"messageType" : 0 as AnyObject,"senderType": "client" as AnyObject])
            MainTabBarController.instance.trip.messages.append(Message(senderType: "client",type: 0, message: messageTxtField.text!, time: ""))
            messageTxtField.text = ""
            messagesTableView.reloadData()
            
            self.messagesTableView.scrollToRow(at: IndexPath(row: MainTabBarController.instance.trip.messages.count-1, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func attachImageAction(_ sender: Any) {
        DialogsHelper.getInstance().takeImage(inViewController: self, title: [LanguageHelper.getStringLocalized(key: "imageAlertTitle"),LanguageHelper.getStringLocalized(key: "camera"),LanguageHelper.getStringLocalized(key: "Photo Library"),LanguageHelper.getStringLocalized(key: "imageAlertCancel")])

    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        imageView.isHidden = true
    }
    
    
}

extension MessagesViewController: MessageReceivedDelegate {
    
    func messageReceived(message: String,type: Int) {
        messagesTableView.reloadData()
        self.messagesTableView.scrollToRow(at: IndexPath(row: MainTabBarController.instance.trip.messages.count-1, section: 0), at: .top, animated: false)
    }
    
    func dismissMessages() {
        dismiss(animated: true, completion: nil)
    }
}

