//
//  ViewController.swift
//  PWCodeChallenge
//
//  Created by Edmund Holderbaum on 5/6/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var petTable: UITableView!
    
    var pets: [Pet] = []
    var openCellTag: Int? = nil
    var cellOpenWidth: CGFloat = 0
    
    let cellOpenedNotification = Notification.Name.init("CellOpened")
    let cellClosedNotification = Notification.Name.init("CellClosed")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pets = Pet.make()
        petTable.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(cellOpened(_:)), name: cellOpenedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cellClosed(_:)), name: cellClosedNotification, object: nil)
    }
    
    @objc func cellOpened(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let tag = userInfo[cellOpenedNotification] as? Int else {
            return
        }
        if let openCellTag = openCellTag, openCellTag != tag, let openCell = petTable.visibleCells.first(where: {$0.tag == openCellTag}) as? CustomCell {
            openCell.animateClosed()
        }
        let indexPath = IndexPath(row: tag, section: 0)
        if let cell = petTable.cellForRow(at: indexPath) as? CustomCell {
            cellOpenWidth = cell.buttonAreaWidthConstraint.constant
            openCellTag = tag
        }
        
    }
    
    @objc func cellClosed(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let tag = userInfo[cellOpenedNotification] as? Int, tag == openCellTag else {
            return
        }
        openCellTag = nil
        cellOpenWidth = 0
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.tag = indexPath.row
        var openWidth: CGFloat = 0
        if indexPath.row == openCellTag {
            openWidth = cellOpenWidth
        }
        cell.setUpWith(pet: pets[indexPath.row], openWidth: openWidth)
        return cell
    }
    
    
}
