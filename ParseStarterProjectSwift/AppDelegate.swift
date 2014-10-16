//
//  AppDelegate.swift
//  ParseStarterProjectSwift
//
//  Created by Du, Xiaochen (Harry) on 10/15/14.
//  Copyright (c) 2014 Where Here Technology. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {

        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        //Parse.setApplicationId("CLIENT_ID", clientKey: "CLIENT_KEY");
        
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // PFFacebookUtils.initializeFacebook();
        // ****************************************************************************
        
        PFUser.enableAutomaticUser();
        var defaultACL: PFACL = PFACL.ACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true);
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true);
        
        if (application.applicationState != UIApplicationState.Background) {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            var preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus");
            var oldPushHandlerOnly = !self.respondsToSelector("application:::");
            
            let noPushPayload = true;
            //= !(launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as Bool);
            
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
            }
        }
        
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            
            var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:UIUserNotificationType.Alert|UIUserNotificationType.Badge|UIUserNotificationType.Sound,categories:nil);
            
            application.registerUserNotificationSettings(settings);
            application.registerForRemoteNotifications();
        } else
            
        {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge |
                UIRemoteNotificationType.Alert |
                UIRemoteNotificationType.Sound);
        }
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        PFPush.storeDeviceToken(deviceToken);
        PFPush.subscribeToChannelInBackground("",target:self, selector:"subscribeFinished::");
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        if (error.code == 3010) {
            NSLog("Push notifications are not supported in the iOS Simulator.");
        } else {
            // show some alert or otherwise handle the failure to register.
            NSLog("application:didFailToRegisterForRemoteNotificationsWithError: \(error)");
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo);
        
        if (application.applicationState == UIApplicationState.Inactive) {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo);
        }
    }
    
    func subscribeFinished(result:NSNumber, error:NSError) {
        if (result.boolValue) {
            
            NSLog("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
        } else {
            NSLog("ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
        }
    }


}

