//
//  MapViewController.swift
//  ToBeDone
//
//  Created by 周星 on 11/11/16.
//  Copyright © 2016 周星. All rights reserved.
//

import Foundation
import MapKit


public class MapViewController : UIViewController, MKMapViewDelegate {
    
    
//    public var onDismissCallback: ((UIViewController) -> ())?
    var location: CLLocation?
    var locationManager = LocationService.sharedInstance
    
    lazy var mapView : MKMapView = { [unowned self] in
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
        return v
        }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        v.image = UIImage(named: "Location_ItemDetail", in: Bundle(for: MapViewController.self), compatibleWith: nil)
        v.image = v.image?.withRenderingMode(.alwaysTemplate)
        v.tintColor = self.view.tintColor
        v.backgroundColor = .clear
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = false
        return v
        }()
    
    let width: CGFloat = 10.0
    let height: CGFloat = 5.0
    
    lazy var ellipse: UIBezierPath = { [unowned self] in
        let ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return ellipse
        }()
    
    
    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        layer.path = self.ellipse.cgPath
        layer.fillColor = UIColor.gray.cgColor
        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineDashPattern = nil
        layer.lineDashPhase = 0.0
        layer.lineJoin = kCALineJoinMiter
        layer.lineWidth = 1.0
        layer.miterLimit = 10.0
        layer.strokeColor = UIColor.gray.cgColor
        return layer
        }()
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
//    convenience public init(_ callback: ((UIViewController) -> ())?){
//        self.init(nibName: nil, bundle: nil)
//        onDismissCallback = callback
//    }
//    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.addSubview(pinView)
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
        

        
        if let value = self.location {
            let region = MKCoordinateRegionMakeWithDistance(value.coordinate, 400, 400)
            mapView.setRegion(region, animated: true)
        }
        else{
            mapView.showsUserLocation = true
        }
        setNavigationController()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let center = mapView.convert(mapView.centerCoordinate, toPointTo: pinView)
        pinView.center = CGPoint(x: center.x, y: center.y - (pinView.bounds.height/2))
        ellipsisLayer.position = center
    }
    
    private func setNavigationController () {
        
        let titleLabel = UILabel.init(frame: CGRect(x:0,y:0,width:100, height: 30))
        
        locationManager.getCurrentPlaceName(placeNameDisplayMode: .concise) { (generatedPlaceName) -> Void in
            titleLabel.text = generatedPlaceName!
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            titleLabel.textColor = UIColor.black
            titleLabel.textAlignment = NSTextAlignment.center
            self.navigationItem.titleView = titleLabel
        }
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.reply, target: self, action: #selector(self.leftNaviBarItemActionForMapView(_:)))
        self.navigationItem.leftBarButtonItem = leftItem
        
    }
    
    
    func leftNaviBarItemActionForMapView (_ sender: UIBarButtonItem) {
        if let navi = self.navigationController {
            navi.popViewController(animated: true)
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y - 10)
        })
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        ellipsisLayer.transform = CATransform3DIdentity
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
        })
        
    }
}
