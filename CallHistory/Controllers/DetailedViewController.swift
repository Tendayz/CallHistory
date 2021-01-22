//
//  DetailedViewController.swift
//  CallHistory
//
//  Created by Stepan Grachev on 22.01.2021.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var swipe: UIImageView!
    @IBOutlet weak var businessNumberLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var businessPhoneLabel: UILabel!
    
    var currentHeight: CGFloat = 200;
    var name: String? = ""
    var phone: String? = ""
    var duration: String? = ""
    var businessPhone: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        circle.layer.cornerRadius = circle.frame.size.width/2
        circle.clipsToBounds = true
        
        circle.layer.shadowColor = UIColor.black.cgColor
        circle.layer.shadowOpacity = 0.1
        circle.layer.shadowOffset = CGSize(width: 0, height: 1)
        circle.layer.shadowRadius = 5
        circle.layer.masksToBounds = false
        
        actionView.setHeight(200)
        actionView.layer.cornerRadius = 20.0
        actionView.clipsToBounds = true
        
        actionView.layer.shadowColor = UIColor.black.cgColor
        actionView.layer.shadowOpacity = 0.2
        actionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        actionView.layer.shadowRadius = 5
        actionView.layer.masksToBounds = false
        
        nameLabel.text = name
        phoneLabel.text = phone
        durationLabel.text = duration
        businessPhoneLabel.text = businessPhone
        
        addGesturesToView()
    }
    
    func addGesturesToView() {
           
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer:)))
           actionView.addGestureRecognizer(panGesture)
       }


    var previousState: MenuState = .Normal
    var currentState: MenuState = .Normal
    @objc func panGestureHandler(recognizer:UIPanGestureRecognizer) {
         
         switch recognizer.state {
         case .possible:
            print("possible")
         case .began:
            print("began")
         case .changed:
            print("changed")
            let location = recognizer.location(in: swipe)
            if currentHeight + recognizer.location(in: swipe).y >= 200 && currentHeight + recognizer.location(in: swipe).y <= 300 {
                currentHeight = currentHeight + recognizer.location(in: swipe).y
                actionView.setHeight(self.currentHeight)
                if currentHeight >= 220 {
                    businessNumberLabel.isHidden = false
                } else {
                    businessNumberLabel.isHidden = true
                }
                
                if currentHeight >= 260 {
                    storeLabel.isHidden = false
                } else {
                    storeLabel.isHidden = true
                }
                
                if currentHeight >= 290 {
                    businessPhoneLabel.isHidden = false
                } else {
                    businessPhoneLabel.isHidden = true
                }
            } else if currentHeight + recognizer.location(in: swipe).y < 200 {
                currentHeight = 200
                actionView.setHeight(currentHeight)
                businessNumberLabel.isHidden = true
                storeLabel.isHidden = true
                businessPhoneLabel.isHidden = true
            } else if currentHeight + recognizer.location(in: swipe).y > 300 {
                currentHeight = 300
                actionView.setHeight(currentHeight)
                businessNumberLabel.isHidden = false
                storeLabel.isHidden = false
                businessPhoneLabel.isHidden = false
            }
            print(location.y)
         case .ended:
            print("ended")
         case .cancelled:
            print("canceled")
         case .failed:
            print("failed")
         @unknown default:
            print("default")
         }
    }
    
    func setHeightToView(height: Int) {
        actionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: actionView.frame.height + CGFloat(height))
    }
    
    indirect enum MenuState {
        case Normal
        case Advanced
    }
}

extension UIView {
    func setHeight(_ h:CGFloat, animateTime:TimeInterval?=nil) {

        if let c = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            c.constant = CGFloat(h)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
