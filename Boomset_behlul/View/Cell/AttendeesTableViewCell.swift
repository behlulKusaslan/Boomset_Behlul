//
//  AttendeesTableViewCell.swift
//  Boomset_behlul
//
//  Created by behlul on 9.12.2018.
//  Copyright © 2018 behlul. All rights reserved.
//

import UIKit

class AttendeesTableViewCell: UITableViewCell, XibLoadable {
    
    // MARK: - Outlets
    @IBOutlet weak var attendeeNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadViewFromXib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadViewFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromXib()
    }
    
    // MARK: - Fuctions
    func configureCell(with attendeesResult: AttendeesResult) {
        let contact = attendeesResult.contact
        let workInfo = attendeesResult.workInfo
        
        attendeeNameLabel.text = "\(contact.prefix ?? "") \(contact.first_name) \(contact.last_name)"
        companyNameLabel.text = "\(workInfo.company)"
        
    }

}

extension AttendeesTableViewCell {
    static let identifier = "AttendeesTableViewCell"
}
