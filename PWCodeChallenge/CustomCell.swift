//
//  CustomCell.swift
//  PWCodeChallenge
//
//  Created by Edmund Holderbaum on 5/6/19.
//  Copyright © 2019 Dawn Trigger Enterprises. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var buttonArea: UIView!
    @IBOutlet weak var buttonAreaWidthConstraint: NSLayoutConstraint!
    
    let cellOpenedNotification = Notification.Name.init("CellOpened")
    let cellClosedNotification = Notification.Name.init("CellClosed")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(changeButtonAreaWidth(sender:)))
        panRecognizer.cancelsTouchesInView = false
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        
    }
    
    func setUpWith(pet: Pet? = nil, openWidth: CGFloat? = nil) {
        if let pet = pet {
            label1.text = pet.name
            label2.text = "\(pet.number)"
        }
        buttonAreaWidthConstraint.constant = openWidth ?? 0
        self.contentView.layoutSubviews()
    }
    
    func addToAreaWidth(_ translation: CGFloat) {
        var const = buttonAreaWidthConstraint.constant
        const += translation
        buttonAreaWidthConstraint.constant = const
        self.contentView.layoutSubviews()
        NotificationCenter.default.post(name: self.cellOpenedNotification, object: nil, userInfo: [self.cellOpenedNotification : self.tag])
    }
    
    func animateTo(width: CGFloat) {
        let max = 0.5 * contentView.frame.width
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.buttonAreaWidthConstraint.constant = max * -1
            self.contentView.layoutIfNeeded()
        }, completion: { _ in
            NotificationCenter.default.post(name: self.cellOpenedNotification, object: nil, userInfo: [self.cellOpenedNotification : self.tag])
        })
    }
    
    func animateClosed() {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.buttonAreaWidthConstraint.constant = 0
                self.contentView.layoutIfNeeded()
            }, completion: { _ in
                NotificationCenter.default.post(name: self.cellClosedNotification, object: nil, userInfo: [self.cellClosedNotification : self.tag])
            })
    }
    
    @objc func changeButtonAreaWidth(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.contentView)
        guard abs(translation.x) > abs(translation.y) * 2 else {
            return
        }
        switch sender.state {
        case .changed:
            if translation.x < 0 {
                addToAreaWidth(translation.x * 0.2)
            }
        case .ended:
            let max = contentView.frame.width * 0.5
            if buttonArea.frame.width > max {
                animateTo(width: max)
            }
            else if translation.x > 0 {
                animateClosed()
            }
        default:
            break
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
