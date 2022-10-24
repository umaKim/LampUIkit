//
//  AppDelegate.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//
import KakaoSDKCommon
import Firebase
import KakaoSDKAuth
import UIKit
import CoreData
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure() 
        KakaoSDK.initSDK(appKey: "ca26661d6b9c87cb37c9d48e988a7cf1")
        GMSServices.provideAPIKey("AIzaSyC5lym-6ogUzurxxOfVYIBantJllGGVhDY")
        return true
    }
}
