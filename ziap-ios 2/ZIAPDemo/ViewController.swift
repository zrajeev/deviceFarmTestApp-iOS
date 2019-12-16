//
//  ViewController.swift
//  ZIAPDemo
//  Copyright © 2018 Zimperium. All rights reserved.
//

import UIKit
import ZDetection
import CoreLocation
import ZDetection.Private

class ViewController: UIViewController {

    var expectedThreat: ZThreatType?
    @IBOutlet weak var statusView: UITextView?
    var statusText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(forName: Notification.Name("com.zimperium.zdetection.locationupdate"),
                                    object: nil, queue: OperationQueue.main, using: {(notification: Notification) in
                                     guard let userInfo = notification.userInfo,
                let newLocation = userInfo["newLocation"] as! CLLocation? else {
                    print("Location: can't get the location.")
                    return
                }
                                                
                let str = "Location: \(String(describing: newLocation))"
                self.statusView?.text = self.statusView!.text + str + "\n"
        })
        
        
        let license = "U2FsdGVkX19cQhtyC15fxVfgEJQeMy1SEAZHbWhLMm20S-_ohEOKPvYTyqo5uaxUnPpqZB_EnmfP1cJNEgv2CP2UmEDhenazWZkyJqIKftr7xeyZCMqBHJk1s_mUk6klVHKhDUxGJ1xnp1HeN1H139Jcp66GHPdZdwZDGGY5lQT6cWM2dd6mKN4xOPGPJmN9SsuPYZ-OzCbFKbU4KnJBbxFwn2prhYqqH60AsqrNc-19VGWuWXnEEhQInSWXpAF0V9HXTeBifwQLyPz6oLIhjoNDyfU7DyKmyLhyTo-unTYyDKQcfrcHfq-a4414m4D-aSY2n2e-zdjZ8pIxWi3KgCQQnzLr_VNpdwKrgmXtBR4rWVZYdDN-ArmYt3sqgLKuM253VwC9uf6Z_lWazczXkU9Q80RgJ1irmmMgZxDn4J4JHpnGLIGWBW-iv15x_YEsF55Kb-eXSQOXUZy6l3QjjqrVzsiaDBYX74EgHqwaeaIrBTzE6S2_mteKP0hH1w3YBQNgWsUYXO_lCIk6YJ4LOOICdGjwGW2MGNSx6he7U5PVpzAhxJWT-Lj4VkLkXu8xIHbAqYa3PL5uaLLyZzZE2nvQ3JcoFRCoTBXwdWjsTTrnwp4fThizM_06aDPq1fuY_TXF1COgsbHnSjcsOmxvPbNITNC-jiN0iGUxoTRkW5lKywqts4HuC9LZkLAyGy-KPqQkxMLRvulq9MIGhQSRVg==".data(using: .utf8)

//        let license = "U2FsdGVkX1+S1/vD0Z9z9cMa499CIeRI0miNw9LwNoXR59WG7kySYFsgd8bMLGESYBCmq/sQzPWIKv2j82gb2fnj4IG4eb3X95AiX9hfTHz2cNdFWaDLnX8pJb8nkJ++1ZrRBVzlmPOTjdL462tt5A==".data(using: .utf8)
        
        var error: NSError?
        
        // Always do this check
        let jailBroken = ZDetection.isRootedOrJailbroken()
        
        print("Jailbroken = \(jailBroken)")
        
        self.statusView?.text.append("IsRootedOrJailbroken = \(jailBroken)"+"\n")
        
        let disposition: ZThreatDisposition = ZThreatDisposition()
        
        self.statusView?.text.append("Device compromised="+disposition.isCompromised().description+"\n")
        
        self.statusView?.text.append("Device rooted="+disposition.isRooted().description+"\n")
        
        //ZDetection.setDeviceId("22009")
        ZDetection.setLicenseKey(license, error: &error)
        
        
        do {
            try ZDetection.setDataFolder("Zimperium")
        } catch {
            print(error)
        }
        
        ZDetection.disableLocation();
        
        ZDetection.addStateCallback{ (old: ZDetectionState?, new: ZDetectionState?) in
           
            
            print("DetectionState: old=\(String(describing: old?.stringify())), new=\(String(describing: new?.stringify()))")
            
            if let state = new {
                self.statusView?.text.append(state.stringify()+"\n")
            }
        }
    
        
        print("Start detectCriticalThreats.")
        
        ZDetection.detectCriticalThreats{ (threat: ZThreat?) in

            print("Threat detected: \(String(describing: threat?.getType()))")

            print("\nThreat Name: \(String(describing: threat?.humanThreatName()))")

            print("\nThreat ID: \(String(describing: threat?.threatInternalId))")


            if threat?.getType() == self.expectedThreat {
                if let t = threat {
                    self.statusView?.text.append("Threat detected: \(t.humanThreatName())\n")
                }

            let alert = UIAlertController(title: threat?.humanThreatName(), message: threat?.humanThreatSummary().string, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
        
//        ZDetection.start { (threat : ZThreat?) in
//
//            print("Threat detected: \(String(describing: threat?.getType()))")
//
//            print("\nThreat Name: \(String(describing: threat?.humanThreatName()))")
//
//            print("\nThreat ID: \(String(describing: threat?.threatInternalId))")
//
//            if let t = threat {
//                self.statusView?.text.append("Threat detected: \(t.humanThreatName())\n")
//            }
//        }
//
        
        
 

    }
 
 

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


    @IBAction func suspiciousAppAttack(sender: UIButton) {
        self.expectedThreat = SUSPICIOUS_IPA
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testSuspiciouAppThreat(attack)
       
    }
    
    @IBAction func deviceCompromised(sender: UIButton) {
        self.expectedThreat = DEVICE_ROOTED
        ZDetection.createZDetectionTester().testThreat(with: self.expectedThreat!)
    }
    
    @IBAction func deviceARPMITM(sender: UIButton) {
        self.expectedThreat = ARP_MITM;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testARPMITMThreat(attack)
    }
    
    @IBAction func deviceRogueAccessPoint(sender: UIButton) {
        self.expectedThreat = ROGUE_ACCESS_POINT;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testRogueAccessPointThreat(attack)
    }
    
    @IBAction func deviceSSLStrip(sender: UIButton) {
        self.expectedThreat = SSL_STRIP;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testSSLStripThreat(attack)
        
        
    }
    
    
    @IBAction func deviceDangerZone(sender: UIButton) {
        self.expectedThreat = SSL_STRIP;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testThreat(with:DANGERZONE_CONNECTED)
    }
    
    @IBAction func deviceCaprivePortal(sender: UIButton) {
        self.expectedThreat = SSL_STRIP;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testThreat(with:CAPTIVE_PORTAL)
    }
    
    @IBAction func deviceUnsecuredNetwork(sender: UIButton) {
        self.expectedThreat = SSL_STRIP;
        
        let attack: ZSimulatedAttack = ZSimulatedAttack()
        attack.setAttackerGatewayIP("192.0.2.0")
        attack.setAttackerGatewayMac("02:00:5E:10:00:00:00:00")
        attack.setAttackerIP("192.0.2.24")
        attack.setAttackerMAC("02:00:5E:10:00:00:00:FF")
        ZDetection.createZDetectionTester().testThreat(with:UNSECURED_WIFI_NETWORK)
    }
    
    

    
    
    
    
    @IBAction func checkDeviceIntegrity(_ sender: Any) {
        
        print("Running Device Integrity...")
        
        self.statusView?.text.append("Running Device Integrity...\n")
        
        ZDetection.checkDeviceIntegrity({
            
//            let alert = UIAlertController(title: "Device Check", message: "Device integrity check completed.", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            
            print("Device Integrity")
//
             //self.statusView?.text.append("Device Integrity completed...\n")
         })
    }
 
  
}

