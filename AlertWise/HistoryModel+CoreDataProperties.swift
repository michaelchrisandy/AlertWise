//
//  HistoryModel+CoreDataProperties.swift
//  AlertWise
//
//  Created by William Chrisandy on 26/11/23.
//
//

import Foundation
import CoreData


extension HistoryModel {
    static let sortDescriptors = [NSSortDescriptor(keyPath: \HistoryModel.actionDate, ascending: false)]

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryModel> {
        let fetchRequest = NSFetchRequest<HistoryModel>(entityName: "HistoryModel")
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
    
    @NSManaged public var actionType: Int32
    @NSManaged public var actionDate: Date

}

extension HistoryModel : Identifiable {

}
