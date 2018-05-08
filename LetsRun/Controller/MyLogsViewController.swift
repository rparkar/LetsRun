//
//  SecondViewController.swift
//  LetsRun
//
//  Created by Rehan Parkar on 2018-05-01.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class MyLogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogCell") as? RunLogCell else {return RunLogCell()}
        
        guard let run = Run.getAllRuns()?[indexPath.row] else {return RunLogCell()}
        cell.configure(run: run)
        
        return cell
    }


}

