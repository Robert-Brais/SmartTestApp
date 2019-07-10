//
//  AppDelegate.swift
//  SmartTestApp
//
//  Created by Robert Brais on 6/26/19.
//  Copyright © 2019 Robert Brais. All rights reserved.
//

import UIKit
import SMART

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // create the client
    let smart = Client(
        baseURL: URL(string: "https://mirrorfhirservice.azurewebsites.net")!,
        settings: [
            "client_id": "38e2e19a-a5d6-4d04-b482-c838ffda8148",
            "authorize_uri": "https://mirrorfhirservice.azurewebsites.net/AadSmartOnFhirProxy/authorize",
            "token_uri": "https://mirrorfhirservice.azurewebsites.net/AadSmartOnFhirProxy/token",
            "authorize_type": "authorization_code",
            "redirect": "customurlscheme://callback"
        ]
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.makeKeyAndVisible()
        // authorize, then search for prescriptions
        smart.authorize() { patient, error in
            if nil != error || nil == patient {
                // report error
            }
            else {
                MedicationRequest.search(["patient": patient!.id])
                    .perform(self.smart.server) { bundle, error in
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
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        // "smart" is your SMART `Client` instance
        if smart.awaitingAuthCallback {
            return smart.didRedirect(to: url)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

