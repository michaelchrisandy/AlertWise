//
//  WelcomePage.swift
//  IOT Project
//
//  Created by William Chrisandy on 17/11/23.
//

import UIKit

class WelcomePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignbackground()
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            print("Notification permission granted: \(granted)")
        }
    }
    
    func assignbackground() {
        let background = UIImage(named: "background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    @IBAction func getStartedBtn(_ sender: Any) {
        
    }
}
