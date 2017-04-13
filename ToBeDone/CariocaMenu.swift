// CariocaMenu.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Arnaud Schloune
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//These keys will be used to save values in NSUserDefaults.
private let CariocaMenuUserDefaultsBoomerangVerticalKey = "com.cariocamenu.boomerang.vertical"
private let CariocaMenuUserDefaultsBoomerangHorizontalKey = "com.cariocamenu.boomerang.horizontal"

///The opening edge of the menu.
///- `LeftEdge`: Left edge of the screen
///- `RightEdge`: Right edge of the screen
@objc public enum CariocaMenuEdge : Int {
    ///Left of the screen
    case leftEdge = 0
    ///Right of the screen
    case rightEdge = 1
}

///The initial vertical position of the menu
///- `Top`: Top of the hostView
///- `Center`: Center of the hostView
///- `Bottom`: Bottom of the hostView
@objc public enum CariocaMenuIndicatorViewPosition : Int {
    ///Top of the hostView
    case top = 0
    ///Center of the hostView
    case center = 1
    ///Bottom of the hostView
    case bottom = 2
}

///The boomerang type of the menu.
///- `None`: Default value. The indicators will always return where they were let.
///- `Vertical`: The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
///- `VerticalAndHorizontal`: The indicators will always come back at the exact same place
@objc public enum CariocaMenuBoomerangType : Int {
    ///Default value. The indicators will always return where they were let.
    case none = 0
    ///The indicators will always come back at the same Y value. They may switch from Edge if the user wants.
    case vertical = 1
    ///The indicators will always come back at the exact same place
    case verticalAndHorizontal = 2
}

//MARK: Delegate Protocol
///Delegate Protocol for events on menu opening/closing
@objc public protocol CariocaMenuDelegate {
    
    ///`Optional` Called when the menu is about to open
    ///- parameters:
    ///  - menu: The opening menu object
    @objc optional func cariocaMenuWillOpen(_ menu:CariocaMenu)
    
    ///`Optional` Called when the menu just opened
    ///- parameters:
    ///  - menu: The opening menu object
    @objc optional func cariocaMenuDidOpen(_ menu:CariocaMenu)
    
    ///`Optional` Called when the menu is about to be dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    @objc optional func cariocaMenuWillClose(_ menu:CariocaMenu)
    
    ///`Optional` Called when the menu is dismissed
    ///- parameters:
    ///  - menu: The disappearing menu object
    @objc optional func cariocaMenuDidClose(_ menu:CariocaMenu)
    
    ///`Optional` Called when a menu item was selected
    ///- parameters:
    ///  - menu: The menu object
    ///  - indexPath: The selected indexPath
    @objc optional func cariocaMenuDidSelect(_ menu:CariocaMenu, indexPath:IndexPath)
}

//MARK: - Datasource Protocol
///DataSource protocol for filling up the menu
@objc public protocol CariocaMenuDataSource {
    
    ///`Required` Gets the menu view, will be used to set constraints
    ///- returns: `UIVIew` the view of the menu that will be displayed
    func getMenuView()->UIView
    
    ///`Optional` Unselects a menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    ///- returns: Nothing. Void
    @objc optional func unselectRowAtIndexPath(_ indexPath: IndexPath) -> Void
    
    ///`Optional` Will be called when the indicator hovers a menu item. You may apply some custom styles to your UITableViewCell
    ///- parameters:
    ///  - indexPath: The preselected indexPath
    @objc optional func preselectRowAtIndexPath(_ indexPath:IndexPath)
    
    ///`Required` Will be called when the user selects a menu item (by tapping or just releasing the indicator)
    ///- parameters:
    ///  - indexPath: The selected indexPath
    func selectRowAtIndexPath(_ indexPath:IndexPath)
    
    ///`Required` Gets the height by each row of the menu. Used for internal calculations
    ///- returns: `CGFloat` The height for each menu item.
    ///- warning: The height should be the same for each row
    ///- todo: Manage different heights for each row
    func heightByMenuItem()->CGFloat
    
    ///`Required` Gets the number of menu items
    ///- returns: `Int` The total number of menu items
    func numberOfMenuItems()->Int
    
    ///`Required` Gets the icon for a specific menu item
    ///- parameters:
    ///  - indexPath: The required indexPath
    ///- returns: `UIImage` The image to show in the indicator. Should be the same that the image displayed in the menu.
    ///- todo: Add emoji support ?👍
    func iconForRowAtIndexPath(_ indexPath:IndexPath)->UIImage
    
    ///`Optional` Sets the selected indexPath
    ///- parameters:
    ///  - indexPath: The selected indexPath
    ///- returns: `Void` Nothing. Nada.
    @objc optional func setSelectedIndexPath(_ indexPath:IndexPath)->Void
    
    ///`Optional` Sets the cell identifier. Used to adapt the tableView cells depending on which side the menu is presented.
    ///- parameters:
    ///  - identifier: The cell identifier
    ///- returns: `Void` Nada. Nothing.
    @objc optional func setCellIdentifierForEdge(_ identifier:String)->Void
}

//MARK: -
///The famous CariocaMenu class
open class CariocaMenu : NSObject, UIGestureRecognizerDelegate {
    
    /**
        Initializes an instance of a `CariocaMenu` object.
        - parameters:
          - dataSource: `CariocaMenuDataSource` The controller presenting your menu
        - returns: An initialized `CariocaMenu` object
    */
    public init(dataSource:CariocaMenuDataSource) {
        self.dataSource = dataSource
        self.menuView = dataSource.getMenuView()
        self.menuHeight = dataSource.heightByMenuItem() * CGFloat(dataSource.numberOfMenuItems())
        self.boomerang = .none
        super.init()
    }
    
    ///The main view of the menu. Will contain the blur effect view, and the menu view. Will match the hostView's frame with AutoLayout constraints.
    fileprivate var containerView = UIView()
    ///The view in which containerView will be added as a subview.
    fileprivate weak var hostView:UIView?
    fileprivate var menuView:UIView
    
    fileprivate var menuTopEdgeConstraint:NSLayoutConstraint?
    
    fileprivate var menuOriginalY:CGFloat = 0.0
    fileprivate var panOriginalY:CGFloat = 0.0
    
    fileprivate var sidePanLeft = UIScreenEdgePanGestureRecognizer()
    fileprivate var sidePanRight = UIScreenEdgePanGestureRecognizer()
    fileprivate var panGestureRecognizer = UIPanGestureRecognizer()
    fileprivate var longPressForDragLeft:UILongPressGestureRecognizer?
    fileprivate var longPressForDragRight:UILongPressGestureRecognizer?
    
    ///The datasource of the menu
    var dataSource:CariocaMenuDataSource
    ///The delegate of events
    open weak var delegate:CariocaMenuDelegate?
    /// The type of boomerang for the menu. Default : None
    open var boomerang:CariocaMenuBoomerangType
    // The color for indicator view
    open var indicatorColor:UIColor?
    /// The selected index of the menu
    open var selectedIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var preSelectedIndexPath:IndexPath!
    
    ///The edge on which the menu will open
    open var openingEdge:CariocaMenuEdge = .leftEdge
    fileprivate let menuHeight:CGFloat
    
    fileprivate var leftIndicatorView:CariocaMenuIndicatorView!
    fileprivate var rightIndicatorView:CariocaMenuIndicatorView!
    fileprivate var indicatorOffset:CGFloat = 0.0
    
    fileprivate var gestureHelperViewLeft:UIView!
    fileprivate var gestureHelperViewRight:UIView!
    
    /// Allows the user to reposition the menu vertically. Should be called AFTER addIn View()
    var isDraggableVertically = false  {
        didSet {
            updateDraggableIndicators()
        }
    }
    
    /// If true, the menu will always stay on screen. If false, it will depend on the user's gestures.
    var isAlwaysOnScreen = true
    
//MARK: - Menu methods
    
    /**
        Adds the menu in the selected view
        - parameters:
            - view: The view in which the menu will be shown, with indicators on top
    */
    open func addInView(_ view:UIView) {
        
        if(hostView == view){
            CariocaMenu.Log("Cannot be added to the same view twice")
            return
        }
        
        hostView = view
        containerView.isHidden = true
        
        addBlur()
        containerView.backgroundColor = UIColor.clear
        hostView?.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        
        hostView?.addConstraints([
            getEqualConstraint(containerView, toItem: hostView!, attribute: .trailing),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .leading),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .bottom),
            getEqualConstraint(containerView, toItem: hostView!, attribute: .top)
        ])
        
        containerView.setNeedsLayout()
        
        //Add the menuview to the container
        containerView.addSubview(menuView)
        
        //Gesture recognizers
        sidePanLeft.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        hostView!.addGestureRecognizer(sidePanLeft)
        sidePanLeft.edges = .left
        
        sidePanRight.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        hostView!.addGestureRecognizer(sidePanRight)
        sidePanRight.edges = .right
        
        panGestureRecognizer.addTarget(self, action: #selector(CariocaMenu.gestureTouched(_:)))
        containerView.addGestureRecognizer(panGestureRecognizer)

        //Autolayout constraints for the menu
        menuView.translatesAutoresizingMaskIntoConstraints = false;
        menuView.addConstraint(NSLayoutConstraint(item: menuView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: menuHeight))
        menuTopEdgeConstraint = getEqualConstraint(menuView, toItem: containerView, attribute: .top)
        containerView.addConstraints([
            getEqualConstraint(menuView, toItem: containerView, attribute: .width),
            getEqualConstraint(menuView, toItem: containerView, attribute: .leading),
            menuTopEdgeConstraint!
        ])
        menuView.setNeedsLayout()
        
        addIndicator(.leftEdge)
        addIndicator(.rightEdge)
        moveToTop()
        
        updateDraggableIndicators()
    }
    
    /**
        Manages the menu dragging vertically
        - parameters:
            - gesture: The long press gesture
    */
    func longPressedForDrag(_ gesture: UIGestureRecognizer) {
        let location = gesture.location(in: containerView)
        let indicator = gesture.view as! CariocaMenuIndicatorView
        
        if(gesture.state == .began) {
            indicator.moveInScreenForDragging()
        }
        
        if(gesture.state == .changed) {
            indicator.updateY(location.y - (indicator.size.height / 2))
        }
        
        if(gesture.state == .ended) {
            indicator.show()
            indicatorOffset = location.y - (indicator.size.height / 2)
            adaptMenuYForIndicatorY(indicator, afterDragging:true)
        }
    }
    
    /**
        Manages the menu position depending on the gesture (UIScreenEdgePanGestureRecognizer and UIPanGestureRecognizer)
        - parameters:
            - gesture: The gesture (EdgePan or Pan)
    */
    func gestureTouched(_ gesture: UIGestureRecognizer) {
    
        let location = gesture.location(in: gesture.view)
        
        //remove the status bar
        let topMinimum:CGFloat = 20.0
        let bottomMaximum = (gesture.view?.frame.height)! - menuHeight
        
        if(gesture.state == .began) {
            
            if(gesture != panGestureRecognizer){
                let newEdge:CariocaMenuEdge = (gesture == sidePanLeft) ? .leftEdge : .rightEdge
                if openingEdge != newEdge {
                    openingEdge = newEdge
                    getIndicatorForEdge((openingEdge == .rightEdge) ? .leftEdge : .rightEdge).hide()
                    dataSource.setCellIdentifierForEdge!((openingEdge == .leftEdge) ? "cellRight" : "cellLeft")
                }
            }
            
            delegate?.cariocaMenuWillOpen!(self)
            showMenu()
            showIndicatorOnTopOfMenu(openingEdge)

            panOriginalY = location.y
            
            //Y to add to match the preselected index
            menuOriginalY = panOriginalY - ((dataSource.heightByMenuItem() * CGFloat((selectedIndexPath as NSIndexPath).row)) + (dataSource.heightByMenuItem()/2))
            
            if isAlwaysOnScreen {
                if menuOriginalY < topMinimum {
                    menuOriginalY = topMinimum
                }
                else if menuOriginalY > bottomMaximum {
                    menuOriginalY = bottomMaximum
                }
            }
            menuTopEdgeConstraint?.constant = menuOriginalY
            
            delegate?.cariocaMenuDidOpen!(self)
        }
        
        if(gesture.state == .changed) {
//            CariocaMenu.Log("changed \(Double(location.y))")
            
            let difference = panOriginalY - location.y
            var newYconstant = menuOriginalY + difference
            
            if isAlwaysOnScreen {
                newYconstant = (newYconstant < topMinimum) ? topMinimum : ((newYconstant > bottomMaximum) ? bottomMaximum : newYconstant)
            }
            
            menuTopEdgeConstraint?.constant = newYconstant
            
            var matchingIndex = Int(floor((location.y - newYconstant) / dataSource.heightByMenuItem()))
            //check if < 0 or > numberOfMenuItems
            matchingIndex = (matchingIndex < 0) ? 0 : ((matchingIndex > (dataSource.numberOfMenuItems()-1)) ? (dataSource.numberOfMenuItems()-1) : matchingIndex)
            
            let calculatedIndexPath = IndexPath(row: matchingIndex, section: 0)
            
            if preSelectedIndexPath !=  calculatedIndexPath {
                if preSelectedIndexPath != nil {
                    dataSource.unselectRowAtIndexPath!(preSelectedIndexPath)
                }
                preSelectedIndexPath = calculatedIndexPath
                dataSource.preselectRowAtIndexPath?(preSelectedIndexPath)
            }
            
            updateIndicatorsForIndexPath(preSelectedIndexPath)
        }
        
        if(gesture.state == .ended){
            menuOriginalY = location.y
            //Unselect the previously selected cell, but first, update the selectedIndexPath
            let indexPathForDeselection = selectedIndexPath
            selectedIndexPath = preSelectedIndexPath
            dataSource.unselectRowAtIndexPath!(indexPathForDeselection)
            didSelectRowAtIndexPath(selectedIndexPath, fromContentController:true)
        }
        
        if gesture.state == .failed { CariocaMenu.Log("Failed : \(gesture)") }
        if gesture.state == .possible { CariocaMenu.Log("Possible : \(gesture)") }
        if gesture.state == .cancelled { CariocaMenu.Log("cancelled : \(gesture)") }
    }
    
    /**
        Calls the delegate actions for row selection
        - parameters:
            - indexPath: The selected index path
            - fromContentController: Bool value precising the source of selection
    */
    open func didSelectRowAtIndexPath(_ indexPath:IndexPath, fromContentController:Bool){
        if preSelectedIndexPath != nil {
            dataSource.unselectRowAtIndexPath!(preSelectedIndexPath)
            preSelectedIndexPath = nil
        }
        //Unselect the previously selected cell, but first, update the selectedIndexPath
        let indexPathForDeselection = selectedIndexPath
        selectedIndexPath = indexPath
        if(!fromContentController){
            dataSource.selectRowAtIndexPath(indexPath)
        }else{
            dataSource.unselectRowAtIndexPath!(indexPathForDeselection)
            dataSource.setSelectedIndexPath!(indexPath)
        }
        delegate?.cariocaMenuDidSelect!(self, indexPath: indexPath)
        updateIndicatorsForIndexPath(indexPath)
        if(fromContentController){
            hideMenu()
        }
    }
    
    ///Gestures management
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    ///Makes sure the containerView is on top of the hostView
    open func moveToTop() {
        hostView?.bringSubview(toFront: containerView)
        if gestureHelperViewLeft != nil{
            hostView?.bringSubview(toFront: gestureHelperViewLeft)
        }
        if gestureHelperViewRight != nil{
            hostView?.bringSubview(toFront: gestureHelperViewRight)
        }
        hostView?.bringSubview(toFront: leftIndicatorView)
        hostView?.bringSubview(toFront: rightIndicatorView)
    }
    
    ///Adds blur to the container view (real blur for iOS > 7)
    fileprivate func addBlur() {
        if (NSClassFromString("UIVisualEffectView") != nil) {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight)) as UIVisualEffectView
            visualEffectView.frame = containerView.bounds
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        }
        else {
            // TODO: add real blur for < iOS8
            let visualEffectView = UIView(frame: containerView.bounds)
            visualEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(visualEffectView)
        }
    }
    
//MARK: - Menu visibility

    ///Shows the menu
    open func showMenu() {
        gestureHelperViewLeft?.isHidden = true
        gestureHelperViewRight?.isHidden = true
        containerView.isHidden = false
        containerView.alpha = 1
        hostView!.layoutIfNeeded()
    }
    
    ///Hides the menu
    open func hideMenu() {
        
        getIndicatorForEdge(openingEdge).restoreOnOriginalEdge(boomerang, completion:{
  
            let edgeToCheckAfterFirstAnimation:CariocaMenuEdge = self.boomerang == .verticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : self.openingEdge
            
            //show back only if it's on the same edge (always true if no horizontal boomerang)
            if edgeToCheckAfterFirstAnimation != self.openingEdge {
                let otherIndicator = self.getIndicatorForEdge(self.openingEdge == .rightEdge ? .leftEdge : .rightEdge)
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                otherIndicator.updateY(offsetSaved)
                otherIndicator.show()
                self.openingEdge = edgeToCheckAfterFirstAnimation
            }
        })

        delegate?.cariocaMenuWillClose!(self)

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.containerView.alpha = 0
            }, completion: { (finished) -> Void in
                self.containerView.isHidden = true
                self.gestureHelperViewLeft?.isHidden = false
                self.gestureHelperViewRight?.isHidden = false
                self.delegate?.cariocaMenuDidClose!(self)
        })
    }
    
//MARK: - Gesture helper views
    
    /**
        Adds Gesture helper views in the container view. Recommended when the whole view scrolls (`UIWebView`,`MKMapView`,...)
        - parameters:
            - edges: An array of `CariocaMenuEdge` on which to show the helpers
            - width: The width of the helper view. Maximum value should be `40`, but you're free to put what you want.
    */
    open func addGestureHelperViews(_ edges:Array<CariocaMenuEdge>, width:CGFloat) {
        
        if(edges.contains(.leftEdge)){
            if(gestureHelperViewLeft != nil){
                gestureHelperViewLeft.removeFromSuperview()
            }
            gestureHelperViewLeft = prepareGestureHelperView(.leading, width:width)
        }
        
        if(edges.contains(.rightEdge)){
            if(gestureHelperViewRight != nil){
                gestureHelperViewRight.removeFromSuperview()
            }
            gestureHelperViewRight = prepareGestureHelperView(.trailing, width:width)
        }
        
        hostView?.bringSubview(toFront: leftIndicatorView)
        hostView?.bringSubview(toFront: rightIndicatorView)
    }
    
    /**
        Generates a gesture helper view with autolayout constraints
        - parameters:
            - edgeAttribute: `.Leading` or `.Trailing`
            - width: The width of the helper view.
        - returns: `UIView` The helper view constrained to the hostView edge
    */
    fileprivate func prepareGestureHelperView(_ edgeAttribute:NSLayoutAttribute, width:CGFloat)->UIView{
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        hostView?.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        hostView?.addConstraints([
            getEqualConstraint(view, toItem: hostView!, attribute: edgeAttribute),
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width),
            getEqualConstraint(view, toItem: hostView!, attribute: .bottom),
            getEqualConstraint(view, toItem: hostView!, attribute: .top)
        ])
        
        view.setNeedsLayout()
        return view
    }

//MARK: - Indicators
    
    /**
        Adds an indicator on a specific edge of the screen
        - parameters:
            - edge: LeftEdge or RightEdge
    */
    fileprivate func addIndicator(_ edge:CariocaMenuEdge){
        
        //TODO: Check if the indicator already exists
        //Default indicator color
        if self.indicatorColor == nil {
            self.indicatorColor = UIColor(red:0.07, green:0.73, blue:0.86, alpha:1)
        }
        
        let indicator = CariocaMenuIndicatorView(indicatorEdge: edge, size:CGSize(width: 47, height: 40), shapeColor:self.indicatorColor!)
        indicator.addInView(hostView!, edge: edge)
        
        if(edge == .leftEdge){
            leftIndicatorView = indicator
        }else{
            rightIndicatorView = indicator
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CariocaMenu.tappedOnIndicatorView(_:)))
        indicator.addGestureRecognizer(tapGesture)
    }
    
    ///Manages the tap on an indicator view
    func tappedOnIndicatorView(_ tap:UIGestureRecognizer){
        let indicator = tap.view as! CariocaMenuIndicatorView
        openingEdge = indicator.edge
        if(menuOriginalY == 0 || boomerang == .vertical || boomerang == .verticalAndHorizontal){
            adaptMenuYForIndicatorY(indicator, afterDragging:false)
        }
        showMenu()
        showIndicatorOnTopOfMenu(openingEdge)
        dataSource.preselectRowAtIndexPath?(selectedIndexPath)
    }
    
    /**
        Adapts the menu Y position depending on the position of the indicator (takes care to not move the menu off screen)
        - parameters:
            - indicator: The indicator to adapt
            - afterDragging: Bool indicating if the new vertical value must be saved for the boomerangs
    */
    fileprivate func adaptMenuYForIndicatorY(_ indicator:CariocaMenuIndicatorView, afterDragging:Bool){
        //preset the menu Y
        //the indicator Y - the selected index Y - the space to center the indicator ((dataSource.heightByMenuItem() - indicatorHeight)/2)
        let indicatorSpace = (dataSource.heightByMenuItem()-indicator.size.height)/2
        var menuY = (indicator.topConstraint?.constant)! - (CGFloat((selectedIndexPath as NSIndexPath).row) * dataSource.heightByMenuItem()) - indicatorSpace
        
        if isAlwaysOnScreen {
            //remove the status bar
            let topMinimum:CGFloat = 20.0
            let bottomMaximum = containerView.frame.height - menuHeight
            //check to not hide the menu
            menuY = (menuY < topMinimum) ? topMinimum : ((menuY > bottomMaximum) ? bottomMaximum : menuY)
        }
        
        menuOriginalY = menuY
        menuTopEdgeConstraint?.constant = CGFloat(menuOriginalY)
        updateIndicatorsForIndexPath(selectedIndexPath)
        dataSource.setCellIdentifierForEdge!((openingEdge == .leftEdge) ? "cellRight" : "cellLeft")
        
        if afterDragging {
            indicatorOffset = (indicator.topConstraint?.constant)!
            UserDefaults.standard.set(Double(indicatorOffset), forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /**
        Shows the indicator on a precise position
        - parameters:
            - edge: Left or right edge
            - position: Top, Center or Bottom
            - offset: A random offset value. Should be negative when position is equal to `.Bottom`
    */
    open func showIndicator(_ edge:CariocaMenuEdge, position:CariocaMenuIndicatorViewPosition, offset:CGFloat){
        indicatorOffset = getIndicatorForEdge(edge).showAt(position, offset: offset)
        UserDefaults.standard.set(Double(indicatorOffset), forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
        UserDefaults.standard.setValue(edge.rawValue, forKey: CariocaMenuUserDefaultsBoomerangHorizontalKey)
        UserDefaults.standard.synchronize()
        openingEdge = edge
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(selectedIndexPath))
    }
    
    ///Shows the indicator on top of the selected menu indexPath
    fileprivate func showIndicatorOnTopOfMenu(_ edge:CariocaMenuEdge){
        getIndicatorForEdge(edge).moveYOverMenu(indicatorOffset, containerWidth:containerView.frame.size.width)
    }
    
    /**
        Returns the right indicator for the asked edge
        - parameters:
            - edge: Left or Right edge
        - returns: `CariocaMenuIndicatorView` The matching indicator
    */
    fileprivate func getIndicatorForEdge(_ edge:CariocaMenuEdge)->CariocaMenuIndicatorView {
        return (edge == .rightEdge) ? rightIndicatorView : leftIndicatorView
    }
    
    /**
        Updates the image inside the indicator, to match the menu item
        - parameters:
            - image: The UIImage to display in the indicator
    */
    func updateIndicatorsImage(_ image:UIImage){
        leftIndicatorView.updateImage(image)
        rightIndicatorView.updateImage(image)
    }
    
    /**
        Updates the indicator position to match the position of a specific indexPath in the menu
        - parameters:
            - indexPath: The concerned indexPath
    */
    fileprivate func updateIndicatorsForIndexPath(_ indexPath:IndexPath){
        let indicator = getIndicatorForEdge(openingEdge)
        //menuTop + index position + center Y for indicator
        indicatorOffset = CGFloat((menuTopEdgeConstraint?.constant)!) + (CGFloat((indexPath as NSIndexPath).row) * dataSource.heightByMenuItem()) + ((dataSource.heightByMenuItem() - indicator.size.height) / 2)
        indicator.updateY(indicatorOffset)
        updateIndicatorsImage(dataSource.iconForRowAtIndexPath(indexPath))
    }
    
//MARK: - Edges
    /**
        Disables a specific edge for the menu (Both edges are active by default)
        - parameters:
            - edge: The edge to disable (Left or Right)
    */
    open func disableEdge(_ edge:CariocaMenuEdge){
        if (hostView != nil){
            hostView?.removeGestureRecognizer((edge == .leftEdge) ? sidePanLeft : sidePanRight)
        }
    }
    
//MARK: - Constraints
    /**
        Generates an Equal constraint
        - returns: `NSlayoutConstraint` an equal constraint for the specified parameters
    */
    fileprivate func getEqualConstraint(_ item: AnyObject, toItem: AnyObject, attribute: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attribute, multiplier: 1, constant: 0)
    }
    
//MARK: - Boomerangs

    /**
        Gets the saved value for the vertical boomerang
        - returns: `CGFloat` The boomerang vertical value
    */
    class func getBoomerangVerticalValue()->CGFloat{
        let offset = UserDefaults.standard.double(forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
        return(CGFloat(offset))
    }
    
    /**
        Gets the saved value for the horizontal boomerang
        - returns: `CariocaMenuEdge` the boomerang matching edge
    */
    class func getBoomerangHorizontalValue()->CariocaMenuEdge{
        let int = UserDefaults.standard.integer(forKey: CariocaMenuUserDefaultsBoomerangHorizontalKey)
        return int == 1 ? .rightEdge : .leftEdge
    }
    
    ///Resets the boomerang saved values
    class func resetBoomerangValues() {
        UserDefaults.standard.setValue(nil, forKey: CariocaMenuUserDefaultsBoomerangVerticalKey)
        UserDefaults.standard.setValue(nil, forKey: CariocaMenuUserDefaultsBoomerangHorizontalKey)
        UserDefaults.standard.synchronize()
    }
    
    ///Enables/disables the indicator drag gesture
    fileprivate func updateDraggableIndicators(){
        
        if isDraggableVertically {
            longPressForDragLeft = UILongPressGestureRecognizer(target: self, action: #selector(CariocaMenu.longPressedForDrag(_:)))
            longPressForDragLeft?.minimumPressDuration = 0.7
            leftIndicatorView.addGestureRecognizer(longPressForDragLeft!)
            longPressForDragRight = UILongPressGestureRecognizer(target: self, action: #selector(CariocaMenu.longPressedForDrag(_:)))
            longPressForDragRight?.minimumPressDuration = 0.7
            rightIndicatorView.addGestureRecognizer(longPressForDragRight!)
        } else {
            
            if longPressForDragLeft != nil {
                leftIndicatorView.removeGestureRecognizer(longPressForDragLeft!)
                longPressForDragLeft = nil
            }
            if longPressForDragRight != nil {
                rightIndicatorView.removeGestureRecognizer(longPressForDragRight!)
                longPressForDragRight = nil
            }
        }
    }
    
//MARK: - Logs
    ///Logs a string in the console
    ///- parameters:
    ///  - log: String to log
    class func Log(_ log:String) {print("CariocaMenu :: \(log)")}
}

//MARK: - IndicatorView Class
///The indicators contained into the menu (one on the left, one on the right)
class CariocaMenuIndicatorView : UIView{
    
    /**
        Initializes an indicator for the menu
        - parameters:
            - indicatoreEdge: Left or Right edge
            - size: The size of the indicator
            - backgroundColor: The background color of the indicator
        - returns: `CariocaMenuIndicatorView` An indicator
    */
    init(indicatorEdge: CariocaMenuEdge, size:CGSize, shapeColor: UIColor) {
        edge = indicatorEdge
        imageView = UIImageView()
        self.size = size
        self.shapeColor = shapeColor
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }
    
    ///Don't know the utility of this code, but seems to be required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///The edge of the indicator. One indicator by edge maximum
    var edge:CariocaMenuEdge
    ///The size of the indicator. Will be used for calculations, needs to be public
    var size:CGSize
    ///The color of the shape
    fileprivate var shapeColor:UIColor
    ///The edge constraint, will depend on the edge. (Trailing or Leading)
    fileprivate var edgeConstraint:NSLayoutConstraint?
    ///The top constraint to adjust the vertical position
    var topConstraint:NSLayoutConstraint?
    ///The imageView to display your nicest icons.
    ///- warning: 👮Don't steal icons.👮
    fileprivate var imageView:UIImageView
    
    ///Drawing of the indicator. The shape was drawed using PaintCode
    override func draw(_ frame: CGRect) {
        
        //This shape was drawed with PaintCode App
        let ovalPath = UIBezierPath()
        
        if(edge == .leftEdge){
            ovalPath.move(to: CGPoint(x: frame.maxX, y: frame.minY + 0.50000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.minY), controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.maxX - 8.95, y: frame.minY))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 1, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.maxX - 31.05, y: frame.minY), controlPoint2: CGPoint(x: frame.minX + 1, y: frame.minY + 0.30000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX - 20, y: frame.maxY), controlPoint1: CGPoint(x: frame.minX + 1, y: frame.minY + 0.70000 * frame.height), controlPoint2: CGPoint(x: frame.maxX - 31.05, y: frame.maxY))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.maxX - 8.95, y: frame.maxY), controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.77614 * frame.height))
            ovalPath.close()
            
        }else{
            //right
            ovalPath.move(to: CGPoint(x: frame.minX + 1, y: frame.minY + 0.50000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 21, y: frame.minY), controlPoint1: CGPoint(x: frame.minX + 1, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.minX + 9.95, y: frame.minY))
            ovalPath.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 32.05, y: frame.minY), controlPoint2: CGPoint(x: frame.maxX, y: frame.minY + 0.30000 * frame.height))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 21, y: frame.maxY), controlPoint1: CGPoint(x: frame.maxX, y: frame.minY + 0.70000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 32.05, y: frame.maxY))
            ovalPath.addCurve(to: CGPoint(x: frame.minX + 1, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 9.95, y: frame.maxY), controlPoint2: CGPoint(x: frame.minX + 1, y: frame.minY + 0.77614 * frame.height))
            ovalPath.close()
        }
        
        ovalPath.close()
        shapeColor.setFill()
        ovalPath.fill()
    }
    
    //MARK: - Indicator methods
    
    /**
        Adds the indicator in the hostView
        - parameters:
            - hostView: The view that will contain the indicator
            - edge: The edge on which to stick the indicator
    */
    func addInView(_ hostView:UIView, edge:CariocaMenuEdge) {
        
        isHidden = true
        hostView.addSubview(self)
        
        var attrSideEdge:NSLayoutAttribute = (edge == .rightEdge) ? .trailing : .leading
        
        topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: hostView, attribute: .top, multiplier: 1, constant: 0)
        
        //hide the indicator, will appear from the outside of the screen
        edgeConstraint = NSLayoutConstraint(item: self, attribute: attrSideEdge, relatedBy: .equal, toItem: hostView, attribute: attrSideEdge, multiplier: 1, constant: getEdgeConstantValue(((size.width + 10) * -1)))
        
        hostView.addConstraints([
            edgeConstraint!,
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.width),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height),
            topConstraint!
            ])
        
        hostView.layoutIfNeeded()
        
        //add Icon imageView
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        //constraints for imageView
        attrSideEdge = (edge == .rightEdge) ? .leading : .trailing
        let valSideEdge:CGFloat = (edge == .rightEdge) ? 10.0 : -10.0
        
        self.addConstraints([
            NSLayoutConstraint(item: imageView, attribute: attrSideEdge, relatedBy: .equal, toItem: self, attribute: attrSideEdge, multiplier: 1, constant: valSideEdge),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            ])
        
        imageView.layoutIfNeeded()
    }

    /**
        Shows the indicator at the demanded position
        - parameters:
            - position: Top, Center or Bottom
            - offset: The offset to adjust the position. Should be negative `if position == .Bottom`
        - returns: `CGFloat` The top constraint constant value
        - todo: Save the final value in %, to avoid problems with multiple orientations
    */
    func showAt(_ position:CariocaMenuIndicatorViewPosition, offset:CGFloat) ->CGFloat{
        
        var yValue:CGFloat = 0
        
        if position == .center {
            yValue = CGFloat((superview!.frame.size.height) / 2.0) - size.height/2
        }
        else if position == .bottom {
            yValue = CGFloat((superview!.frame.size.height)) - size.height
        }
        else if position == .top {
            yValue = 20
        }
    
        updateY(offset+yValue)
        superview!.layoutIfNeeded()
        superview!.bringSubview(toFront: self)
        show()
        
        return (topConstraint?.constant)!
    }
    
    /**
        Updates the Y position of the indicator
        - parameters:
            - y: The new value for the top constraint
    */
    func updateY(_ y:CGFloat){
        topConstraint?.constant = y
    }
    
    /**
        Restores the indicator on its initial position, depending on the boomerang type of the menu
        - parameters:
            - boomerang: The boomerang of the menu
            - completion: A completionBlock called when the animation is finished.
    */
    func restoreOnOriginalEdge(_ boomerang:CariocaMenuBoomerangType, completion: @escaping (() -> Void)){
        superview!.layoutIfNeeded()
        
        let isBoomerang = (boomerang != .none)
        //different positions if boomerang or not
        let position1 = isBoomerang ? getEdgeConstantValue(-80.0) : getEdgeConstantValue(-20.0)
        let position2 = isBoomerang ? position1 : getEdgeConstantValue(nil)
        
        let edgeToCheckAfterFirstAnimation:CariocaMenuEdge = boomerang == .verticalAndHorizontal ? CariocaMenu.getBoomerangHorizontalValue() : edge
        
        animateX(position1, speed1:0.2, position2: position2, speed2:0.2, completion:{
            
            if isBoomerang{
                let offsetSaved = CariocaMenu.getBoomerangVerticalValue()
                if offsetSaved != 0.0{
                    self.updateY(offsetSaved)
                    self.superview!.layoutIfNeeded()
                    //show back only if it's on the same edge (always true if no horizontal boomerang)
                    if edgeToCheckAfterFirstAnimation == self.edge {
                        self.show()
                    }
                    completion()
                }
            }
        })
    }

    /**
        Adapts the Y position of the indicator, while being on top of the menu
        - parameters:
            - y: The new vertical position
            - containerWidth: The width of the hostView used to animate the indicator X position
    */
    func moveYOverMenu(_ y:CGFloat,containerWidth:CGFloat){
//        CariocaMenu.Log("moveYOverMenu \(y)")
        topConstraint?.constant = y
        superview!.layoutIfNeeded()
        superview!.bringSubview(toFront: self)
        isHidden = false
        
        animateX(getEdgeConstantValue(containerWidth - self.size.width + 10), speed1 :0.2, position2: getEdgeConstantValue(containerWidth - (self.size.width + 1)), speed2 :0.2, completion:{
            
        })
    }
    
    ///Hides the indicator
    func hide(){
//        CariocaMenu.Log("hide \(self)")
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            }, completion: { (finished) -> Void in
                self.isHidden = true
        }) 
    }
    
    ///Shows the indicator
    func show(){
//        CariocaMenu.Log("show \(self)")
        isHidden = false
        animateX(getEdgeConstantValue(0.0), speed1 :0.2, position2: getEdgeConstantValue(nil), speed2:0.4, completion:{
            
        })
    }
    
    ///Moves the indicator on the edge of the screen, when the user longPressed on it.
    func moveInScreenForDragging(){
//        CariocaMenu.Log("moveInScreenForDragging\(self)")
        animateX(getEdgeConstantValue(-5.0), speed1 :0.2, position2: getEdgeConstantValue(0.0), speed2:0.4, completion:{
            
        })
    }
    
    /**
        Updates the indicator's image
        - parameters:
            - image: An UIImage to display in the indicator
    */
    func updateImage(_ image:UIImage){
        imageView.image = image
    }
    
    //MARK: Internal methods
    
    /**
        Animates the X position of the indicator, in two separate animations
        - parameters:
            - position1: The X position of the first animation
            - spped1: The duration of the first animation
            - position2: The X position of the second animation
            - spped2: The duration of the second animation
            - completion: the completionBlock called when the two animations are finished
    */
    fileprivate func animateX(_ position1:CGFloat, speed1:Double, position2:CGFloat, speed2:Double, completion: @escaping (() -> Void)){
        
        edgeConstraint?.constant = position1
        UIView.animate(withDuration: speed1,delay:0, options: [.curveEaseIn], animations: { () -> Void in
            self.superview!.layoutIfNeeded()
            
            }) { (finished) -> Void in
                
                self.edgeConstraint?.constant = position2
                UIView.animate(withDuration: speed2,delay:0, options: [.curveEaseOut], animations: { () -> Void in
                    self.superview!.layoutIfNeeded()
                    
                    }) { (finished) -> Void in
                        completion()
                }
        }
    }
    
    /**
        Calculates the value to set to the edgeConstraint. (Negative or positive, depending on the edge)
        - parameters:
            - value: The value to transform
        - returns: `CGFloat` The value to set to the constant of the edgeConstraint
    */
    fileprivate func getEdgeConstantValue(_ value:CGFloat!)->CGFloat{
        let val = (value != nil) ? value : -5.0
        return (edge == .rightEdge) ? (val! * -1) :  val!
    }
}
