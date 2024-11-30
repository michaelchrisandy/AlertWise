//
//  HomePage.swift
//  IOT Project
//
//  Created by William Chrisandy on 17/11/23.
//

import UIKit
import CoreData
import FirebaseMessaging

class HomePage: UIViewController {

    var container: NSPersistentContainer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var histories: [HistoryModel] = []
    
    @IBOutlet weak var statusBtn: UIButton!

    @IBOutlet weak var statusImg: UIImageView!
    
    @IBOutlet weak var statusLbl: UILabel!
    var checkStatus: Bool? = false
    
    @IBOutlet weak var historyBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        refreshData()
    }
    
    func updateView() {
        let status = UserDefaults.standard.bool(forKey: AppConstants.protectedKey)
        if(status) {
            buttonProtected()
        }
        else {
            buttonUnprotected()
        }
        animateStatusLabel()
    }
    

    @IBAction func statusBtnClicked(_ sender: Any) {
        let status = UserDefaults.standard.bool(forKey: AppConstants.protectedKey)
        UserDefaults.standard.set(!status, forKey: AppConstants.protectedKey)
        if(status){
            addHistory(actionType: 2)
        }
        else{
            addHistory(actionType: 1)
        }
        updateView()
        
        UIView.animate(withDuration: 1.0) {
            self.statusImg.alpha = 0
        }
        
        UIView.animate(withDuration: 1.5) {
            self.statusImg.alpha = 1.0
        }
        
    }
    
    
    func buttonProtected(){
        statusBtn.tintColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.1)
        statusBtn.setTitle("Unprotect", for: .normal)
        statusBtn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
        
        statusImg.image = UIImage(named: "lock")
    }
    
    func buttonUnprotected(){
        statusBtn.tintColor = UIColor(red: 0, green: 0.9, blue: 0, alpha: 0.1)
        statusBtn.setTitle("Protect", for: .normal)
        statusBtn.setTitleColor(UIColor(red: 0, green: 1, blue: 0, alpha: 1), for: .normal)
        
        statusImg.image = UIImage(named: "unlock")
    }
    
    func animateStatusLabel() {
            UIView.animate(withDuration: 0.5, animations: {
                // Animate the label moving to the right
                self.statusLbl.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            }) { _ in
                // Change label text and reset its position
                
                let status = UserDefaults.standard.bool(forKey: AppConstants.protectedKey)
                self.statusLbl.text = status ? "Protected" : "Unprotected"
                self.statusLbl.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)

                UIView.animate(withDuration: 0.5) {
                    // Animate the label moving from the left
                    self.statusLbl.transform = .identity
                }
            }
        }
    
    func addHistory(actionType: Int32){
        let history = HistoryModel(context: context)
        history.actionType = actionType
        history.actionDate = Date()
        context.insert(history)
        
        do {
            try context.save()
        }
        catch let error {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo), \(nsError.localizedDescription)")
        }
        
        statusBtn.isEnabled = false
        
        if actionType == 1 {
            //locked.
            Messaging.messaging().subscribe(toTopic: AppConstants.notificationTopic) {
                [weak self] error in
                if let error {
                    print("Error subscribing to \"\(AppConstants.notificationTopic)\" topic: \(error)")
                }
                print("Subscribed to \"\(AppConstants.notificationTopic)\" topic")
                self?.statusBtn.isEnabled = true
            }
        }
        else {
            Messaging.messaging().unsubscribe(fromTopic: AppConstants.notificationTopic) {
                [weak self] error in
                if let error {
                    print("Error unsubscribing to \"\(AppConstants.notificationTopic)\" topic: \(error)")
                }
                print("Unsubscribed to \"\(AppConstants.notificationTopic)\" topic")
                self?.statusBtn.isEnabled = true
            }
        }
        
        refreshData()
    }
    
    func refreshData(){
        do {
            let fetchRequest: NSFetchRequest<HistoryModel> = HistoryModel.fetchRequest()
            let histories = try context.fetch(fetchRequest)
            self.histories = histories
        }
        catch let error {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo), \(nsError.localizedDescription)")
        }
    }
}
