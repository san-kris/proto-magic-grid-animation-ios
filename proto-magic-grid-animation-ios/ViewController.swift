 //
//  ViewController.swift
//  proto-magic-grid-animation-ios
//
//  Created by Santosh Krishnamurthy on 3/15/23.
//

import UIKit

class ViewController: UIViewController {

    // Number of boxes per row
    let numViewPerRow = 15
    // Number of rows
    let numViewPerColumn = 33
    
    // create an empty dictionary of cells
    var cells = [String: UIView]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setStartPointForDrand()
        
        // calculate the width of the box
        let boxWidth = view.frame.width / CGFloat(numViewPerRow)
        
        // for each row
        for j in 0...numViewPerColumn{
            // for each column in row
            for i in 0...numViewPerRow{
                // crate a new view
                let boxView = UIView()
                // assign a random color
                boxView.backgroundColor = randomColor()
                // create and assign a frame
                boxView.frame = CGRect(x: CGFloat(i) * boxWidth, y: CGFloat(j) * boxWidth, width: boxWidth, height: boxWidth)
                // Add a border to each box
                boxView.layer.borderWidth = 0.5
                // change border color
                boxView.layer.borderColor = UIColor.black.cgColor
                // add new view as subview
                view.addSubview(boxView)
                let key = "\(j):\(i)"
                cells[key] = boxView
            }

        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    private var previousCell: UIView?
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) -> Void {
        let location = gesture.location(in: view)
        
        // calculate the width of the box
        let boxWidth = view.frame.width / CGFloat(numViewPerRow)
        let col = Int(location.x / boxWidth)
        let row = Int(location.y / boxWidth)
        
        print("Row: \(row); Col: \(col)")
        
        
        if let cell = cells["\(row):\(col)"]{
            
            if previousCell != cell{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.previousCell?.layer.transform = CATransform3DIdentity
                } completion: { done in
                    print("identity animation complete")
                }
                previousCell = cell

            }
            
            view.bringSubviewToFront(cell)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                cell.layer.transform = CATransform3DMakeScale(3, 3, 3)
            }
            
            if gesture.state == .ended{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                    cell.layer.transform = CATransform3DIdentity
                } completion: { done in
                    print("last identity animation complete")
                }
            }

        }
        


        /*
        // using hitTest to get the view
        if let hitView = view.hitTest(location, with: nil){
            
            let NewhitView = hitView as UIView
            NewhitView.backgroundColor = .black
        }
         */
        
    }
    
    private func setStartPointForDrand(){
        let time = Int( NSDate().timeIntervalSinceReferenceDate )
        srand48(time)
        
    }
    
    fileprivate func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }


}

