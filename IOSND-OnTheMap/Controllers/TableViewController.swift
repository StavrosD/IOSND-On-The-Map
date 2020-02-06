//
//  TableViewController.swift
//  IOSND-OnTheMap
//
//  Created by Dimopoulos Stavros tou Athanasiou on 29/1/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, CommonCodeProtocol {
    @IBOutlet var studentLocationsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //    (tabBarController as? TabBarControllerViewController)?.refresh(self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //if studentLocations.isEmpty {return 0}
        print(studentInformation.count)
        return  studentInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationReuseCell") as!
        StudentsTableViewCell
        // Configure the cell...
        let studentLocation = studentInformation[indexPath.row]
        cell.nameLabel.text =  "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.hyperlink.text = studentLocation.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openURL(url: studentInformation[indexPath.row].mediaURL)
    }
}
