//
//  ViewController.swift
//  TinderLike
//
//  Created by Haldun Bayhantopcu on 28/10/15.
//  Copyright © 2015 monoid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(makeDraggableView())
    }
    
    func makeDraggableView() -> DraggableView {
        let draggableView = DraggableView()
        draggableView.frame.size = CGSize(width: 200, height: 260)
        draggableView.center = view.center
        draggableView.backgroundColor = UIColor.random()
        draggableView.delegate = self
        return draggableView
    }
}

extension ViewController: DraggableViewDelegate {
    
    func draggableView(view: DraggableView, didFinishedDragging distance: CGVector) {
        if fabs(distance.dx) > 150 {
            UIView.animateWithDuration(0.2, animations: {
                view.center.x += distance.dx * 2.0
            }, completion: { _ in
                view.removeFromSuperview()
                delay(0.2) {
                    self.view.addSubview(self.makeDraggableView())
                }
            })
        } else {
            view.resetViewPositionAndTransformations()
        }
    }
}

protocol DraggableViewDelegate: class {
    func draggableView(view: DraggableView, didFinishedDragging distance: CGVector)
}

class DraggableView: UIView {
    
    weak var delegate: DraggableViewDelegate?
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originalPoint: CGPoint?
    
    init() {
        super.init(frame: CGRectZero)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    deinit {
        removeGestureRecognizer(panGestureRecognizer)
    }
    
    func commonSetup() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "dragged:")
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        let distanceX = gestureRecognizer.translationInView(self).x
        let distanceY = gestureRecognizer.translationInView(self).y
        
        switch gestureRecognizer.state {
        case .Began:
            originalPoint = center
            break
        case .Changed:
            let rotationStrength = min(distanceX / 320.0, 1.0)
            let rotationAngle = 2 * CGFloat(M_PI) * rotationStrength / 16.0
            let scaleStrength = 1 - fabs(rotationStrength) / 4.0
            let scale = max(scaleStrength, 0.93)
            center = CGPoint(x: originalPoint!.x + distanceX, y: originalPoint!.y + distanceY)
            let rotationTransform = CGAffineTransformMakeRotation(rotationAngle)
            self.transform = CGAffineTransformScale(rotationTransform, scale, scale)
        case .Ended:
            delegate?.draggableView(self, didFinishedDragging: CGVector(dx: distanceX, dy: distanceY))
        case .Possible:
            fallthrough
        case .Cancelled:
            fallthrough
        case .Failed:
            break
        }
    }
    
    func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2) {
            self.center = self.originalPoint!
            self.transform = CGAffineTransformIdentity
        }
    }
}


extension UIColor {
    class func random() -> UIColor {
        let r: CGFloat = CGFloat(drand48())
        let g: CGFloat = CGFloat(drand48())
        let b: CGFloat = CGFloat(drand48())
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
