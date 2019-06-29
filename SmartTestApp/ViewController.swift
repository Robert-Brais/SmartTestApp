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
            baseURL: URL(string: "https://fhir-api-dstu2.smarthealthit.org")!,
            settings: [
                //"client_id": "my_mobile_app",       // if you have one
                "redirect": "smartapp://callback",    // must be registered
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

