//
//  HistoryPage.swift
//  AlertWise
//
//  Created by William Chrisandy on 26/11/23.
//

import UIKit
import CoreData

class HistoryPage: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var container: NSPersistentContainer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var histories: [HistoryModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryTableViewCell
        
        let idx = indexPath.row
        let history = histories[idx]
        
        if(history.actionType == 1) {
            cell.cellImage.image = UIImage(named: "lock")
            cell.cellContentLbl.text = "Protected"
        }
        else if(history.actionType == 2){
            cell.cellImage.image = UIImage(named: "unlock")
            cell.cellContentLbl.text = "Unprotected"
        }
        else{
            cell.cellImage.image = UIImage(named: "passed")
            cell.cellContentLbl.text = "Someone passed"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MMM yyyy"
        cell.cellSubContentLbl.text = dateFormatter.string(from: history.actionDate)
        
        return cell
    }
    
}
