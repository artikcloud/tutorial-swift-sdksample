# ARTIK Cloud Swift SDK starter code

This sample code sends and gets a message to and from ARTIK Cloud. It uses the [ARTIK Cloud Swift SDK](https://github.com/artikcloud/artikcloud-swift) to make REST API calls.

### Prerequisites
* xcode >= 7.3
* ARTIK Cloud Swift SDK

### Setup / Installation:

 1. Sign into [My ARTIK Cloud](https://artik.cloud/)
 2. On the device dashboard, click to connect a new device. Select the Demo Fire Sensor (from cloud.artik.sample.demofiresensor) and name your sensor SampleFireSensor (or any name you'd like).
 3. Click the Settings icon of the device you just added. Get the **device ID** and **device token**. If the token does not already exist, click "GENERATE DEVICE TOKEN…" to get one.
 4. Install ARTIK Cloud Swift SDK by following [Installation](https://github.com/artikcloud/artikcloud-swift) instructions.
```swift
public class Config {
    static let DEVICEID = "999aaabbbcccdddeeefffggg"
    static let DEVICETOKEN = "000111222333444555aaabbbccc"
    init(){ }
}
```

## Run the code
  - Open the 'tutorial-swift-artikcloud-sdksample.xcworkspace' in Xcode IDE.
  - Navigate to menu Product -> Run. This will launch the iOS Simulator to run the app.

### 1. Send a message 
Click the Send Message button in the app.  This will send a random temperature value to ARTIK Cloud on behalf of the device. 

If everything goes well, you will receive a response with a message id (mid). ARTIK Cloud uses this response to acknowledge the receipt of the message.   It will look something like this:
```
"mid": "a98a9203f5b74764869ef539a6cfe921"
```

### 2. Get a message
Click the Get Message button in the app to get the latest message. The response below has the 'temp' value that was sent earlier, and the matching 'mid' (message id).

```
Optional("dt856e54302a294fba80414b87eb7b79a3"), 
"data": Optional(["temp": 101]), 
"mid": Optional("a98a9203f5b74764869ef539a6cfe921"), 
"ts": Optional(1475690084261)]
```

## Peek into the implementation
Take a closer look at the following files:
* ViewController.swift 

Import the artikcloud package:

```swift
import ArtikCloudSwift
```

Setup credentials for your api call. Here we have used the device token to make our API calls.

```swift
ArtikCloudAPI.customHeaders["Authorization"] = "bearer " + Config.DEVICETOKEN
```

Create a Message Object with a temperature value for sending to ARTIK Cloud 
```swift
let message = Message()

//source device id
message.sdid = Config.DEVICEID

// set random temperature value for the device
message.data!["temp"] = Int(arc4random_uniform(200))
```

The two methods MessagesAPI.sendMessage(...) and MessagesAPI.getLastNormalizedMessages(...) are the part of the MessagesAPI. These are called respectively in the onSendMessage() and onGetMessage() UI handlers.

```swift
//send message

//data - the Message object from earlier containing sdid (source device id) and the random temperature value
MessagesAPI.sendMessage(data: message)
```

```swift
let sdid = Config.DEVICEID

//gets the last messages sent to device
MessagesAPI.getLastNormalizedMessages(sdids: sdid)
```

## View your data in My ARTIK Cloud

Have you visited ARTIK Cloud [data visualization tool](https://artik.cloud/my/data)?

Select your device from the charts to view your device data in realtime.   Try sending a message multiple times to send a few random values.  Here's a screenshot:

![GitHub Logo](https://github.com/artikcloud/tutorial-python-sdksample/blob/master/img/screenshot-firesensor-datachart.png)

## More examples

Peek into [tests](https://github.com/artikcloud/artikcloud-swift/tree/master/ArtikCloudTests/ArtikCloudClientTests) in ARTIK Cloud Swift SDK for more SDK usage examples.

More about ARTIK Cloud
---------------

If you are not familiar with ARTIK Cloud, we have extensive documentation at https://developer.artik.cloud/documentation

The full ARTIK Cloud API specification can be found at https://developer.artik.cloud/documentation/api-reference/

Peek into advanced sample applications at https://developer.artik.cloud/documentation/samples/

To create and manage your services and devices on ARTIK Cloud, visit the Developer Dashboard at https://developer.artik.cloud

License and Copyright
---------------------

Licensed under the Apache License. See [LICENSE](LICENSE).

Copyright (c) 2016 Samsung Electronics Co., Ltd.

