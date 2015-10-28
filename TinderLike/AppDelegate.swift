//
//  AppDelegate.swift
//  TinderLike
//
//  Created by Haldun Bayhantopcu on 28/10/15.
//  Copyright © 2015 monoid. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

