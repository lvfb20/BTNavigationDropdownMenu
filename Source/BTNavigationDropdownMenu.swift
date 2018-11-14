//
//  BTConfiguration.swift
//  BTNavigationDropdownMenu
//
//  Created by Pham Ba Tho on 6/30/15.
//  Copyright (c) 2015 PHAM BA THO. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

// MARK: BTNavigationDropdownMenu
public class BTNavigationDropdownMenu: UIView {
    
    // The color of menu title. Default is darkGrayColor()
    public var menuTitleColor: UIColor! {
        get {
            return self.configuration.menuTitleColor
        }
        set(value) {
            self.configuration.menuTitleColor = value
        }
    }
    
    // The height of the cell. Default is 50
    public var cellHeight: CGFloat! {
        get {
            return self.configuration.cellHeight
        }
        set(value) {
            self.configuration.cellHeight = value
        }
    }
    
    // The color of the cell background. Default is whiteColor()
    public var cellBackgroundColor: UIColor! {
        get {
            return self.configuration.cellBackgroundColor
        }
        set(color) {
            self.configuration.cellBackgroundColor = color
        }
    }
    
    public var cellSeparatorColor: UIColor! {
        get {
            return self.configuration.cellSeparatorColor
        }
        set(value) {
            self.configuration.cellSeparatorColor = value
        }
    }
    
    // The color of the text inside cell. Default is darkGrayColor()
    public var cellTextLabelColor: UIColor! {
        get {
            return self.configuration.cellTextLabelColor
        }
        set(value) {
            self.configuration.cellTextLabelColor = value
        }
    }
    
    // The font of the text inside cell. Default is HelveticaNeue-Bold, size 19
    public var cellTextLabelFont: UIFont! {
        get {
            return self.configuration.cellTextLabelFont
        }
        set(value) {
            self.configuration.cellTextLabelFont = value
            self.menuTitle.font = self.configuration.cellTextLabelFont
        }
    }
    
    // The color of the cell when the cell is selected. Default is lightGrayColor()
    public var cellSelectionColor: UIColor! {
        get {
            return self.configuration.cellSelectionColor
        }
        set(value) {
            self.configuration.cellSelectionColor = value
        }
    }
    
    // The checkmark icon of the cell
    public var checkMarkImage: UIImage! {
        get {
            return self.configuration.checkMarkImage
        }
        set(value) {
            self.configuration.checkMarkImage = value
        }
    }
    
    // The animation duration of showing/hiding menu. Default is 0.3
    public var animationDuration: TimeInterval! {
        get {
            return self.configuration.animationDuration
        }
        set(value) {
            self.configuration.animationDuration = value
        }
    }
    
    // The arrow next to navigation title
    public var arrowImage: UIImage! {
        get {
            return self.configuration.arrowImage
        }
        set(value) {
            self.configuration.arrowImage = value
            self.menuArrow.image = self.configuration.arrowImage
        }
    }
    
    // The padding between navigation title and arrow
    public var arrowPadding: CGFloat! {
        get {
            return self.configuration.arrowPadding
        }
        set(value) {
            self.configuration.arrowPadding = value
        }
    }
    
    // The color of the mask layer. Default is blackColor()
    public var maskBackgroundColor: UIColor! {
        get {
            return self.configuration.maskBackgroundColor
        }
        set(value) {
            self.configuration.maskBackgroundColor = value
        }
    }
    
    // The opacity of the mask layer. Default is 0.3
    public var maskBackgroundOpacity: CGFloat! {
        get {
            return self.configuration.maskBackgroundOpacity
        }
        set(value) {
            self.configuration.maskBackgroundOpacity = value
        }
    }
    
    // The icon image prior to navigation title
    public var iconImage: UIImage! {
        get {
            return self.configuration.iconImage
        }
        set(value) {
            self.configuration.iconImage = value
            self.menuIcon.image = self.configuration.iconImage
        }
    }
    
    // The padding between navigation icon and title
    public var iconPadding: CGFloat! {
        get {
            return self.configuration.iconPadding
        }
        set(value) {
            self.configuration.iconPadding = value
        }
    }
    
    public var didSelectItemAtIndexHandler: ((_ indexPath: Int) -> ())?
    
    private var navigationController: UINavigationController?
    private var configuration = BTConfiguration()
    private var topSeparator: UIView!
    private var menuButton: UIButton!
    private var menuTitle: UILabel!
    private var menuArrow: UIImageView!
    private var menuIcon: UIImageView!
    private var backgroundView: UIView!
    private var tableView: BTTableView!
    public var items: [AnyObject]! {
        set { tableView.items = newValue; tableView.reloadData() }
        get { return tableView.items }
    }
    private var isShown: Bool!
    private var menuWrapper: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, items: [AnyObject], navigationController: UINavigationController? = nil) {
        
        // Navigation controller
        self.navigationController = navigationController ?? UIApplication.shared.keyWindow?.rootViewController?.topMostViewController?.navigationController
        
        // Get titleSize
        let titleSize = (title as NSString).size(withAttributes: [NSAttributedStringKey.font: self.configuration.cellTextLabelFont])
        
        // Set frame
        let frame = CGRect(x: 0, y: 0, width: titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage.size.width)*2, height: self.navigationController!.navigationBar.frame.height)
        
        super.init(frame:frame)
        
        self.navigationController?.view.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        self.isShown = false
        
        // Init properties
        self.setupDefaultConfiguration()
        
        // Init button as navigation title
        self.menuButton = UIButton(frame: frame)
        self.menuButton.addTarget(self, action: #selector(menuButtonTapped(sender:)), for: .touchUpInside)
        self.addSubview(self.menuButton)
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle.text = title
        self.menuTitle.textColor = self.menuTitleColor
        self.menuTitle.textAlignment = .center
        self.menuTitle.font = self.configuration.cellTextLabelFont
        self.menuButton.addSubview(self.menuTitle)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage)
        self.menuButton.addSubview(self.menuArrow)
        
        self.menuIcon = UIImageView(image: self.configuration.iconImage)
        self.menuButton.addSubview(self.menuIcon)
        
        let window = UIApplication.shared.keyWindow!
        let menuWrapperBounds = window.bounds
        
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRect(x: menuWrapperBounds.origin.x, y: 0, width: menuWrapperBounds.width, height: menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor
        self.backgroundView.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
        
        // Init table view
        
        var height = menuWrapperBounds.height
        if height > window.frame.height - 90 {
            height = window.frame.height - 90
        }
        
        self.tableView = BTTableView(frame: CGRect(x: menuWrapperBounds.origin.x, y: menuWrapperBounds.origin.y + 0.5, width: menuWrapperBounds.width, height: height + 300), items: items, configuration: self.configuration)
        
        self.tableView.selectRowAtIndexPathHandler = {[weak self] (indexPath: Int) -> () in
            self?.didSelectItemAtIndexHandler!(indexPath)
            self?.setMenuTitle(title: self?.items[indexPath] as? String ?? "")
            self?.hideMenu()
            self?.isShown = false
            self?.layoutSubviews()
        }
        
        self.tableView.selectedIndexPath = (items as? [String])?.index(of: title)
        
        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.backgroundView)
        self.menuWrapper.addSubview(self.tableView)
        
        // Add Line on top
        self.topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: menuWrapperBounds.size.width, height: 0.5))
        self.topSeparator.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.menuWrapper.addSubview(self.topSeparator)
        
        // Add Menu View to container view
        window.addSubview(self.menuWrapper)
        
        // By default, hide menu view
        self.menuWrapper.isHidden = true
        
        // final to set items
        self.items = items
        
    }
    
    deinit {
        self.navigationController?.view.removeObserver(self, forKeyPath: "frame")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            // Set up DropdownMenu
            self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
            self.tableView.reloadData()
        }
    }
    
    override public func layoutSubviews() {
        self.menuTitle.sizeToFit()
        self.menuTitle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.menuArrow.sizeToFit()
        self.menuArrow.center = CGPoint(x: self.menuTitle.frame.maxX + self.configuration.arrowPadding, y: self.frame.size.height/2)
        self.menuIcon.sizeToFit()
        if self.menuIcon.frame.size.width > 0 {
            self.menuIcon.center = CGPoint(x: self.menuTitle.frame.minX - self.configuration.iconPadding - self.menuIcon.frame.size.width/2, y: self.frame.size.height/2)
        }
    }
    
    func setupDefaultConfiguration() {
        self.menuTitleColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor // Setter
        self.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        self.cellSeparatorColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
        self.cellTextLabelColor = self.navigationController?.navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
    }
    
    func showMenu() {
        
        if isShown == true { return }
        isShown = true
        
        self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
        
        // Table view header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView
        
        self.topSeparator.backgroundColor = self.configuration.cellSeparatorColor
        
        // Rotate arrow
        self.rotateArrow()
        
        // Visible menu view
        self.menuWrapper.isHidden = false
        
        // Change background alpha
        self.backgroundView.alpha = 0
        
        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
        
        // Reload data to dismiss highlight color of selected cell
        self.tableView.reloadData()
        
        UIView.animate(
            withDuration: self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        }, completion: nil
        )
    }
    
    public func hideMenu() {
        
        if isShown == false { return }
        isShown = false
        
        // Rotate arrow
        self.rotateArrow()
        
        // Change background alpha
        self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        
        UIView.animate(
            withDuration: self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
        }, completion: nil
        )
        
        // Animation
        UIView.animate(withDuration: self.configuration.animationDuration, delay: 0, options: [], animations: {
            self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
            self.backgroundView.alpha = 0
        }, completion: { _ in
            self.menuWrapper.isHidden = true
        })
    }
    
    func rotateArrow() {
        UIView.animate(withDuration: self.configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(Double.pi/180))
            }
        })
    }
    
    public func setMenuTitle(title: String) {
        self.menuTitle.text = title
    }
    
    @objc func menuButtonTapped(sender: UIButton) {
        if isShown != true {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    public func registerNib(nib: UINib?) {
        let cellId = "cell"
        tableView.reusedCellId = cellId
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = configuration.cellSeparatorColor
    }
    
    public var cellConfig: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> ())? {
        get { return tableView.cellConfig }
        set { tableView.cellConfig = newValue }
    }
    
    
}

// MARK: BTConfiguration
class BTConfiguration {
    var menuTitleColor: UIColor?
    var cellHeight: CGFloat!
    var cellBackgroundColor: UIColor?
    var cellSeparatorColor: UIColor?
    var cellTextLabelColor: UIColor?
    var cellTextLabelFont: UIFont!
    var cellSelectionColor: UIColor?
    var checkMarkImage: UIImage!
    var arrowImage: UIImage!
    var iconImage: UIImage!
    var arrowPadding: CGFloat!
    var iconPadding: CGFloat!
    var animationDuration: TimeInterval!
    var maskBackgroundColor: UIColor!
    var maskBackgroundOpacity: CGFloat!
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        // Path for image
        let bundle = Bundle(for: BTConfiguration.self)
        let url = bundle.url(forResource: "BTNavigationDropdownMenu", withExtension: "bundle")
        let imageBundle = Bundle(url: url!)
        
        let checkMarkImagePath = imageBundle?.path(forResource: "checkmark_icon", ofType: "png")
        let arrowImagePath = imageBundle?.path(forResource: "arrow_down_icon", ofType: "png")
        
        // Default values
        self.menuTitleColor = .darkGray
        self.cellHeight = 50
        self.cellBackgroundColor = .white
        self.cellSeparatorColor = .darkGray
        self.cellTextLabelColor = .darkGray
        self.cellTextLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.cellSelectionColor = .lightGray
        self.checkMarkImage = UIImage(contentsOfFile: checkMarkImagePath!)
        self.animationDuration = 0.5
        self.arrowImage = UIImage(contentsOfFile: arrowImagePath!)
        self.arrowPadding = 15
        self.iconPadding = 5
        self.maskBackgroundColor = .black
        self.maskBackgroundOpacity = 0.3
    }
}

// MARK: Table View
class BTTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: BTConfiguration!
    var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> ())?
    
    var reusedCellId: String?
    var cellConfig: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> ())?
    
    // Private properties
    open var items: [AnyObject]!
    var selectedIndexPath: Int!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [AnyObject], configuration: BTConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        self.items = items
        self.selectedIndexPath = 0
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cellId = reusedCellId {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cellConfig?(cell, indexPath)
            return cell
        }
        
        let cell = BTTableViewCell(style: .default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row] as? String
        cell.checkmarkIcon.isHidden = (indexPath.row == selectedIndexPath) ? false : true
        
        return cell
    }
    
    // Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath.row)
        self.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as? BTTableViewCell
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? BTTableViewCell
        cell?.checkmarkIcon.isHidden = true
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
    }
}

// MARK: Table view cell
class BTTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: BTConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: BTConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRect(x: 0, y: 0, width:  (UIApplication.shared.keyWindow?.frame.width ?? 0), height: self.configuration.cellHeight)
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        self.selectionStyle = .none
        self.textLabel!.textAlignment = .left
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        self.textLabel!.font = self.configuration.cellTextLabelFont
        self.textLabel!.frame = CGRect(x: 20, y: 0, width: cellContentFrame.width, height: cellContentFrame.height)
        
        // Checkmark icon
        self.checkmarkIcon = UIImageView(frame: CGRect(x: cellContentFrame.width - 50, y: (cellContentFrame.height - 30)/2, width: 30, height: 30))
        self.checkmarkIcon.isHidden = true
        self.checkmarkIcon.image = self.configuration.checkMarkImage
        self.checkmarkIcon.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(self.checkmarkIcon)
        
        // Separator for cell
        let separator = BTTableCellContentView(frame: cellContentFrame)
        if let cellSeparatorColor = self.configuration.cellSeparatorColor {
            separator.separatorColor = cellSeparatorColor
        }
        self.contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class BTTableCellContentView: UIView {
    var separatorColor: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Set separator color of dropdown menu based on barStyle
        context.setStrokeColor(self.separatorColor.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: 0, y: self.bounds.size.height))
        context.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        context.strokePath()
    }
}

extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}
