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

extension UIView {
   /**
     Rotate a view by specified degrees
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
}

//MARK:- Arrow
enum PointerDirection {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    let shapeLayer = CAShapeLayer()
    var arrowColor:UIColor = .black {
        didSet{
            shapeLayer.fillColor = arrowColor.cgColor
        }
    }
    
    var pointerDirection: PointerDirection = .down {
        didSet{
            switch pointerDirection {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break

            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break

            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break

            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
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


//MARK:-
class ScaleBarCell : UITableViewCell {
    var indicatorView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(indicatorView)
        self.selectionStyle = .none
        
        //..
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
        
        //..
        self.contentView.addSubview(indicatorView)
        self.selectionStyle = .none
    }
}

//MARK:-
class ScaleBarHeader : UITableViewHeaderFooterView {
    let label = UILabel()
    let indicatorView = UIView()
    var setHorizontal : Bool = true {
        didSet {
            self.label.textAlignment = .right
            self.label.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
    }
    
    var font : UIFont! {
        didSet {
            self.label.font = self.font
        }
    }
    
    var textColor : UIColor? {
        didSet {
            self.label.textColor = self.textColor
        }
    }

    var indicatorColor : UIColor = .gray {
        didSet {
            self.indicatorView.backgroundColor = self.indicatorColor
        }
    }
    
    override var frame: CGRect {
        didSet {
            setupUI()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        var f = self.frame
        f.origin = .zero
        f.size.height = 2
        indicatorView.frame = f
        self.addSubview(indicatorView)
        
        f = self.frame
        f.size.height -= 6
        f.origin.y = 6
        label.frame = f
        self.addSubview(label)
    }
}

//..
class ScalePointer : UIView {
    let valueLabel = UILabel()
    let scArrow = Arrow(origin: .zero, size: 12)
    let scScaleLable = UILabel()
    let scLineView = UIView()
    var color : UIColor! = .blue {
        didSet {
            scLineView.backgroundColor = color
            scScaleLable.textColor = color
            valueLabel.textColor = color
            scArrow.arrowColor = color
        }
    }
    
    func rotateSubViews (angle:CGFloat) {
        self.scScaleLable.rotate(angle:angle)
        self.valueLabel.rotate(angle:angle)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        setupUI()
        
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        scScaleLable.adjustsFontSizeToFitWidth = true
        scScaleLable.minimumScaleFactor = 0.5
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //..
        setupUI()
    }
    
    /**
            Function is called tight after view s initialized and then set up UI for system.
     */
    func setupUI () {
        var f = self.frame
        f.origin.y = 0
        f.size.width = 64
        f.origin.x = 80
        valueLabel.frame = f
        valueLabel.textAlignment = .center
        self.addSubview(valueLabel)
        
        f.origin.x += f.size.width + 4
        f.origin.y = f.size.height / 2 - scArrow.frame.size.height / 2
        f.size = scArrow.frame.size
        scArrow.frame = f
        scArrow.pointerDirection = .right
        self.addSubview(scArrow)
        
        f.origin.x += f.size.width + 8
        f.size = self.frame.size
        f.size.width = 24
        f.origin.y = 0
        scScaleLable.frame = f
        scScaleLable.textAlignment = .center
        self.addSubview(scScaleLable)
        
        f.origin.x += f.size.width + 8
        f.size.width = self.frame.size.width - f.origin.x
        f.size.height = 2
        f.origin.y = self.frame.size.height / 2 - f.size.height / 2
        scLineView.frame = f
        self.addSubview(scLineView)
    }
}

@available(iOS 8.2, *)
open class RPTScaleView : UIView, UITableViewDelegate, UITableViewDataSource  {
    //MARK: IBInspectable
    @IBInspectable public var scale : String = "cm"
    @IBInspectable public var font : UIFont = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
    @IBInspectable public var textColor : UIColor = .green
    @IBInspectable public var color : UIColor = .green
    @IBInspectable public var selectionColor : UIColor = .blue
    
    @IBInspectable public var interval: Int = 10
    @IBInspectable public var range : NSRange = NSMakeRange(0, 1000)
    @IBInspectable  public var setHorizontal: Bool = true {
        didSet{
            self.rotate(angle: (setHorizontal) ? 90 : 0)
        }
    }
    
    var table : UITableView!
    var pointer : ScalePointer!
    
    var  selectedValue : Int = 0
    public var delegate : RPTScaleViewDelegate? {
        didSet {
            self.selectedValue = self.delegate?.selectedValue(view: self, scale: self.scale) ?? 0
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
        //addScaleTable
        addScaleTable()
        
        //..
        addIndicatorArrow()
        
        //..
        if selectedValue != 0 {
            self.delay(0.3) {
                self.scrollTo(selected: self.selectedValue)
            }
        }
    }
    
    func scrollTo(selected value:Int) {
        let fV = value - range.location
        let section = fV / interval
        let row = fV % interval
        let ip = IndexPath(row: row, section: section)
        self.table.scrollToRow(at: ip, at: .middle, animated: true)
    }
    
    //UITableViewDelegate, UITableViewDataSource
    func addScaleTable () {
        var cf = self.frame//calculated frame
        if setHorizontal == true {
            cf.size.width = self.frame.size.height
            cf.size.height = self.frame.size.width
        }
        var f = cf
        
        /*let h = f.size.height / 3
        f.origin.y -= h / 2
        f.size.height += h*/
        
        var w = f.size.width / 6
        w = (w > 60) ? w : 60
        f.origin.x = f.size.width - w
        f.size.width = w
        f.origin.y = 0
        
        let table = UITableView(frame: f, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        print ("table.decelerationRate = ", table.decelerationRate)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.bounces = false
        table.backgroundColor = .clear
        
        //for scrollable padding
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: cf.size.height / 2))
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: cf.size.height / 2))
        if setHorizontal == true {
            table.transform = CGAffineTransform(scaleX: 1, y: -1);
        }

        self.table = table
        self.addSubview(table)
    }
    
    func addIndicatorArrow() {
        var cf = self.frame//calculated frame
        if setHorizontal == true {
            cf.size.width = self.frame.size.height
            cf.size.height = self.frame.size.width
        }
        var f = cf

        f.size.height = 60
        f.origin.y = cf.size.height / 2 - f.size.height / 2
        f.origin.x = 0
        let pointer = ScalePointer(frame: f)
        pointer.color = selectionColor
        pointer.scScaleLable.text = scale
        
        var fnt = font
        pointer.scScaleLable.font = fnt
        pointer.valueLabel.text = "\(selectedValue)"
        fnt = font.withSize(font.pointSize * 2)
        pointer.valueLabel.font = fnt
        if setHorizontal == true {
            pointer.rotateSubViews(angle: -90)
        }
        
        self.pointer = pointer
        self.addSubview(pointer)
    }
    
    //MARK:
    //UITableViewDataSource
    // returns the # of rows in each component..
    public func numberOfSections(in tableView: UITableView) -> Int {
        return (range.length - range.location) / interval
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interval
    }

    //UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indicatorCellIdentifier = (indexPath.row % 5 == 0) ? "segmentIndicatorCellIdentifier"  : "indicatorCellIdentifier"
        var cell : ScaleBarCell!
        if let c = tableView.dequeueReusableCell(withIdentifier: indicatorCellIdentifier) as? ScaleBarCell {
            cell = c
        } else {
            cell = ScaleBarCell(style: .default, reuseIdentifier: indicatorCellIdentifier)
            var w = tableView.frame.size.width / 2
            var h : CGFloat = 0.75
            if (indexPath.row % 5 == 0) {
                w = tableView.frame.size.width / 1.5
                h = 1.5
            }
            let f = CGRect(x: tableView.frame.size.width - w, y: CGFloat(0), width: w, height: h)
            cell.indicatorView.frame = f
            cell.indicatorView.backgroundColor = color
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 8
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var hv : ScaleBarHeader!
        if let v = tableView.dequeueReusableHeaderFooterView(withIdentifier: "scaleIndicatorHeader") as? ScaleBarHeader {
            hv = v
        } else {
            hv = ScaleBarHeader(reuseIdentifier: "scaleIndicatorHeader")
            var f = CGRect.zero
            f.size.height = 32
            f.size.width = tableView.frame.size.width
            hv.frame = f
            hv.textColor = textColor
            hv.indicatorColor = color
            hv.font = font
            if setHorizontal == true {
                hv.setHorizontal = setHorizontal
            }
        }
        let t = String(format: "%2d", ((section + 1) * interval) + (range.location - 1))
        hv.label.text = "\(t)\(scale)"
        return hv
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 32
    }
    
    //Snap
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let ch : CGFloat = 8
        targetContentOffset.pointee.y = round(targetContentOffset.pointee.y / ch) * ch
    }
 
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var cp  = self.table.center
        cp.x = 20
        cp.y += scrollView.contentOffset.y
        //print("cp = ", cp, "IndexPath: ", self.table.indexPathForRow(at: cp) ?? "Nohing", "scrollView.contentOffset.y = ", scrollView.contentOffset.y)
        if let ip = self.table.indexPathForRow(at: cp) {
            self.selectedValue = range.location + ip.section * interval + ip.row
            self.pointer.valueLabel.text = "\(self.selectedValue)"
        }
        //print("cp = ", cp, "IndexPath: ", self.table.indexPathForRow(at: cp) ?? "Nohing")
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var cp  = self.table.center
        cp.x = 20
        cp.y += scrollView.contentOffset.y
        //print("cp = ", cp, "IndexPath: ", self.table.indexPathForRow(at: cp) ?? "Nothing", "scrollView.contentOffset.y = ", scrollView.contentOffset.y)
        if let ip = self.table.indexPathForRow(at: cp) {
            self.selectedValue = range.location + ip.section * interval + ip.row
            self.pointer.valueLabel.text = "\(self.selectedValue)"
        }
        self.delegate?.scale(view: self, scale: self.scale, value: self.selectedValue)
    }
}

public protocol RPTScaleViewDelegate {
    @available(iOS 8.2, *)
    func scale(view:RPTScaleView, scale:String, value:Int)
    
    @available(iOS 8.2, *)
    func selectedValue(view:RPTScaleView, scale:String) -> Int?
}
