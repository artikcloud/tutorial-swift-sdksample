
import UIKit
import ArtikCloudSwift3


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
        
        MessagesAPI.sendMessage(data: message, completion: { response, error in
            
            if let errorMessage = error?.localizedDescription {
                self.textOutput.text = errorMessage
                return
            }
            
            self.textOutput.text = response?.data?.mid;
            
        })
        
    }
    
    
    //handler for when user clicks on Get Message.
    //returns the last message that was sent to your device device
    func onGetMessage() {
        
        textOutput.text = "Getting Message ..."
 
        let sdid = Config.DEVICEID
        
        //ARTIK Cloud API call which retrieves the last messages sent to the device
        //@sdids - list of source device id's
        
        MessagesAPI.getLastNormalizedMessages(sdids: "\(sdid)", completion: { response, error in
            
            if let errorMessage = error?.localizedDescription {
                self.textOutput.text = "Got Error while caling getLastNormalizedMessage:" + errorMessage
                return
            }
            
            
            let normalizedMessage = (response?.data)! as [NormalizedMessage]
            
            if normalizedMessage.isEmpty == true {
                self.textOutput.text = "No messages"
                return
            }
            
            let responseObject:[String:Any] = [
            
                "mid": normalizedMessage[0].mid!,
                "ts": normalizedMessage[0].ts!,
                "sdtid": normalizedMessage[0].sdtid!,
                "data": normalizedMessage[0].data!
            ]
            
            self.textOutput.text = responseObject.description
            
        })
        
    }

    
    //sends a random value for device ARTIK Cloud
    @IBAction func btnSendMessage(_ sender: AnyObject) {
        
        onSendMessage()
        
    }

    //receive last sent message to ARTIK Cloud for the device
    @IBAction func btnGetMessage(_ sender: AnyObject) {
        
        onGetMessage()
    }
    
    //visual output
    @IBOutlet weak var textOutput: UITextView!
}

