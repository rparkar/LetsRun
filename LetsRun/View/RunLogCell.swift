//
//  RunLogCell.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-07.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {
    
    //outlets
    
    @IBOutlet weak var runDurationLabel: UILabel!
    @IBOutlet weak var totalDIstanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(run: Run) {
        
        totalDIstanceLabel.text = "\(run.distance.metersToMiles(places: 2)) mi"
        runDurationLabel.text = run.duration.formatTimeDurationToString()
        dateLabel.text = "\(run.date)"
        averagePaceLabel.text = run.pace.formatTimeDurationToString()
        
        
    }


}
