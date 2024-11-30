//
//  AboutUsPage.swift
//  IOT Project
//
//  Created by William Chrisandy on 18/11/23.
//

import UIKit

class AboutUsPage: UIViewController {
    
    @IBOutlet weak var developersImage: UIImageView!
    
    @IBOutlet weak var authorName1Lbl: UILabel!
    @IBOutlet weak var authorDesc1Lbl: UILabel!
    
    @IBOutlet weak var authorName2Lbl: UILabel!
    @IBOutlet weak var authorDesc2Lbl: UILabel!
    
    @IBOutlet weak var authorName3Lbl: UILabel!
    @IBOutlet weak var authorDesc3Lbl: UILabel!
    
    
    @IBOutlet weak var aboutAppImg: UIImageView!
    @IBOutlet weak var aboutAppLbl: UILabel!
    
    
    @IBOutlet weak var contactUsLbl: UILabel!
    @IBOutlet weak var ourVisionLbl: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMeetTheDeveloper()
        setAboutApp()
        setOurVision()
        setContactUs()
        
        
//      buat dynamic but not working
        
//        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
//            rect = rect.union(view.frame)
//        }
//        scrollView.contentSize = contentRect.size
    }
    
    func setMeetTheDeveloper() {
        developersImage.image = UIImage(named: "2")
        
        authorName1Lbl.text = AppConstants.authorName1
        authorDesc1Lbl.text = AppConstants.authorDesc1
        authorDesc1Lbl.numberOfLines = 0
        authorDesc1Lbl.lineBreakMode = .byWordWrapping
        
        authorName2Lbl.text = AppConstants.authorName2
        authorDesc2Lbl.text = AppConstants.authorDesc2
        authorDesc2Lbl.numberOfLines = 0
        authorDesc2Lbl.lineBreakMode = .byWordWrapping
        
        authorName3Lbl.text = AppConstants.authorName3
        authorDesc3Lbl.text = AppConstants.authorDesc3
        authorDesc3Lbl.numberOfLines = 0
        authorDesc3Lbl.lineBreakMode = .byWordWrapping
    }
    
    func setAboutApp() {
        aboutAppImg.image = UIImage(named: "1")
        
        aboutAppLbl.text = AppConstants.aboutAppDesc
        aboutAppLbl.numberOfLines = 0
        aboutAppLbl.lineBreakMode = .byWordWrapping
    }
    
    func setOurVision() {
        ourVisionLbl.text = AppConstants.ourVisionDesc
        
        ourVisionLbl.numberOfLines = 0
        ourVisionLbl.lineBreakMode = .byWordWrapping
    }
    
    func setContactUs() {
        contactUsLbl.text = AppConstants.contactUsDesc
        
        contactUsLbl.numberOfLines = 0
        contactUsLbl.lineBreakMode = .byWordWrapping
    }
}
