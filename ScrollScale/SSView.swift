//
//  SSProperties.swift
//  ScrollScale
//
//  Created by Arpit on 1/8/20.
//  Copyright © 2020 Arpit. All rights reserved.
//

import UIKit

extension NSObject {
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = (DispatchTime.now() + delay)
        DispatchQueue.main.asyncAfter(deadline:when, execute: closure)
    }
}

open class RPTScaleView : UIView, UIPickerViewDelegate, UIPickerViewDataSource  {
    //MARK: IBInspectable
    @IBInspectable public var scale : String = "cm"
    @IBInspectable public var interval: Int = 10
    @IBInspectable public var color : UIColor = .green
    @IBInspectable public var minValue = 0
    @IBInspectable public var maxValue = 1000
    @IBInspectable  public var isVertical: Bool = true {
        didSet{
            rotateScale()
        }
    }
    
    func rotateScale() {
        
    }

    //..
    var indicator : Indicator!
    @IBInspectable public var arrowSize: CGFloat = 15 {
        didSet{
            let center = indicator.superview!.center
            indicator.frame = CGRect(x: center.x - arrowSize/2, y: center.y - arrowSize/2, width: arrowSize, height: arrowSize)
        }
    }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.delay(0.1) {
            self.setupUI()
        }
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.delay(0.1) {
            self.setupUI()
        }
    }
    
    func setupUI()  {
        //addScalePicker
        addScalePicker()
    }
    
    //UITableViewDelegate, UITableViewDataSource
    func addScalePicker () {
        var f = self.frame
        let h = f.size.height / 3
        f.origin.y -= h / 2
        f.size.height += h
        
        var w = f.size.width / 6 
        w = (w > 60) ? w : 60
        f.origin.x = f.size.width - w
        f.size.width = w
        let picker = UIPickerView(frame: f)
        picker.delegate = self
        picker.dataSource = self
        self.addSubview(picker)
    }
    
    //MARK:
    //UIPickerViewDataSource
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0 || $0.frame.height > 2
        })
        return 1
    }
   
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxValue
    }

    //UIPickerViewDelegate
    //static let indicatorView
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var indexView : UIView!
        if let v = view {
            indexView = v
        }else {
            var w = pickerView.frame.size.width / 2
            var h : CGFloat = 1
            if (row % 5 == 0) {
                w = pickerView.frame.size.width
                h = 2
            }
            
            let f = CGRect(x: pickerView.frame.size.width - w, y: CGFloat(0), width: w, height: h)
            indexView = UIView(frame:f)
            indexView.backgroundColor = color
        }
        return indexView
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 8
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

//Arrow
class Indicator: UIView {
    let shapeLayer = CAShapeLayer()
    var arrowColor:UIColor = .black {
        didSet{
            shapeLayer.fillColor = arrowColor.cgColor
        }
    }
    
    init(origin: CGPoint, size: CGFloat ) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func draw(_ rect: CGRect) {
        // Get size
        let size = self.layer.frame.width

        // Create path
        let bezierPath = UIBezierPath()

        // Draw points
        let qSize = size/4

        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size/2, y: qSize*3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        bezierPath.close()

        // Mask to path
        shapeLayer.path = bezierPath.cgPath
       
        if #available(iOS 12.0, *) {
            self.layer.addSublayer (shapeLayer)
        } else {
            self.layer.mask = shapeLayer
        }
    }
}
