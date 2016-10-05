//
//  ViewController.swift
//  tutorial-swift-artikcloud-sdksample
//
//  Created by Jonathan Paek on 9/20/16.
//  Copyright © 2016 ARTIK Cloud. All rights reserved.
//

import UIKit
import ArtikCloudSwift


class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCredentials();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    //here we have chosen to use the device token to set credentials for simplicity.
    //token may require a user access token, for example, for other API calls.
    func initCredentials() {
        
        ArtikCloudAPI.customHeaders["Authorization"] = "bearer " + Config.DEVICETOKEN
    }
    
    //handler for when user clicks on send message.
    //this will trigger the ARTIK Cloud MessagesAPI.sendMessage to send data
    //for your device identified in the Config.swift file.
    func onSendMessage() {
        
        
        textOutput.text = "Sending Message ..."
        
        // Build Message object set with minimum
        // parameters needed for request.
        //   sdid - the device id
        //   data - data for the device
        
        let message = Message()
        message.sdid = Config.DEVICEID
        
        // set the data for the device
        // this should match properties of your device type with
        // respective fields and data type for the device
        message.data =  [
            "temp": 101
        ]
        
        
        //ARTIK Cloud API call which sends the message object.
        //returns response with 'mid', unique message identifier if successful.
        MessagesAPI.sendMessage(data: message).then { response -> Void in
            
  
            let responseText:String = "Response:" + String("mid:", response.data?.mid)
            
            self.textOutput.text = responseText;
            
            }.error { error -> Void in

                self.textOutput.text = "Error Send Message: " + String(error)
                
        }
        
    }
    
    
    //handler for when user clicks on Get Message.
    //returns the last message that was sent to your device device
    func onGetMessage() {
        
        textOutput.text = "Getting Message ..."
 
        let sdid = Config.DEVICEID
        
        //ARTIK Cloud API call which retrieves the last messages sent to the device
        //@sdids - list of source device id's
    
        MessagesAPI.getLastNormalizedMessages(sdids: sdid).then { response -> Void in
            
            
            let normalizedMessage = response.data! as [NormalizedMessage]
            
            // move along if no messages
            if normalizedMessage.isEmpty == true {
                
                self.textOutput.text = "No messages"
                return
                
            }
            
            // for simplicity we retrieve only the first message and output
            // only a few member variables available in the NormalizedMessage object.
            // @param data - contains the original data that was sent to the device earlier.
            let responseObject:[String:AnyObject] = [
                "mid": String(normalizedMessage[0].mid),
                "ts": String(normalizedMessage[0].ts),
                "sdtid": String(normalizedMessage[0].sdtid),
                "data": String(normalizedMessage[0].data)
            ]
            
            self.textOutput.text = responseObject.description
            
            }.error { error -> Void in
                
                print(String(format: "%s", String(error)))
                self.textOutput.text = "Get Message Error: " + String(error)
                
        }
        
    }

    
    //sends a random value for device ARTIK Cloud
    @IBAction func btnSendMessage(sender: AnyObject) {
        
        onSendMessage()
        
    }

    //receive last sent message to ARTIK Cloud for the device
    @IBAction func btnGetMessage(sender: AnyObject) {
        
        onGetMessage()
    }
    
    //visual output
    @IBOutlet weak var textOutput: UITextView!
}

