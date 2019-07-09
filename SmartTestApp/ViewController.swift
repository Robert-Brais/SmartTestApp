//
//  ViewController.swift
//  SmartTestApp
//
//  Created by Robert Brais on 6/26/19.
//  Copyright © 2019 Robert Brais. All rights reserved.
//

import UIKit
import Foundation
import SMART

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // create the client
        let smart = Client(
            baseURL: URL(string: "https://mirrorfhirservice.azurewebsites.net")!,
            settings: [
                "client_id": "38e2e19a-a5d6-4d04-b482-c838ffda8148",
                "authorize_uri": "https://mirrorfhirservice.azurewebsites.net/AadSmartOnFhirProxy/authorize",
                "token_uri": "https://mirrorfhirservice.azurewebsites.net/AadSmartOnFhirProxy/token",
                "authorize_type": "authorization_code",
                "redirect": "mirrorfhirapp://callback"
            ]
        )
        
        // authorize, then search for prescriptions
        smart.authorize() { patient, error in
            if nil != error || nil == patient {
                // report error
            }
            else {
                MedicationRequest.search(["patient": patient!.id])
                    .perform(smart.server) { bundle, error in
                        if nil != error {
                            // report error
                        }
                        else {
                            var meds = bundle?.entry?
                                .filter() { return $0.resource is MedicationRequest }
                                .map() { return $0.resource as! MedicationRequest }
                            
                            // now `meds` holds all the patient's orders (or is nil)
                        }
                }
            }
        }
    }


}

