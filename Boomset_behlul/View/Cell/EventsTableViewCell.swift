//
//  EventsTableViewCell.swift
//  Boomset_behlul
//
//  Created by behlul on 6.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell, XibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    fileprivate func dateToString(date: Date, format: DateFormat) -> String {
        let formatter = DateFormatter()
        switch format {
        case .long:
            formatter.dateFormat = "EEEE, MMM d, HH:mm"
        case .short:
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
    
    fileprivate func stringToDate(from stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: stringDate)
        return date ?? Date()
    }
    
    fileprivate func setEventDate(with object: EventResult) -> String {
        let startDate = stringToDate(from: object.startsat)
        let endDate = stringToDate(from: object.endsat)
        
        let startDateString = dateToString(date: startDate, format: .long)
        let endDateString = dateToString(date: endDate, format: .short)
        
        return "\(startDateString) - \(endDateString)"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadViewFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromXib()
    }
    
    func configureCell(with object: EventResult) {
        eventNameLabel.text = object.name
        eventDateLabel.text = setEventDate(with: object)
    }
    
}

extension EventsTableViewCell {
    static let identifier = "EventsTableViewCell"
    
    fileprivate enum DateFormat {
        case long
        case short
    }
}
