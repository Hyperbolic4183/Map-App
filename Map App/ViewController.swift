//
//  ViewController.swift
//  Map App
//
//  Created by 大塚周 on 2020/04/21.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, UITextFieldDelegate {
    var latitudeValue:Float?
    var longitudeValue:Float?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var latitudeSlider: UISlider!
    @IBOutlet weak var longitudeSlider: UISlider!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        latitudeValue = 35.6815
        longitudeValue = 139.752
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(80.0,139.752)
        mapView.setCenter(location, animated: true)
        latitudeLabel.text = "緯度は\(80.0)です"
        longitudeLabel.text = "経度は\(139.752)です"
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchKey = textField.text!
        textField.resignFirstResponder()
        let geocoder = CLGeocoder()  //CLGeocoderのインスタンス化
        geocoder.geocodeAddressString(searchKey, completionHandler: {(placemarks, error) in
            
            if let unwrapPlacemarks = placemarks {//複数の位置情報が格納された配列unrapPlacemarks
                if let firstPlacemark = unwrapPlacemarks.first {//unrapPlacemarksの先頭の要素を抜き出す
                    if let location = firstPlacemark.location {//firstPlacemarksのうち緯度経度情報のみを抜き出す
                        let targetCoordinate = location.coordinate
                        let targetLatiude:Float = Float(targetCoordinate.latitude)
                        let targetLongitude:Float = Float(targetCoordinate.longitude)
                        print(targetCoordinate)
                        
                        //検索結果の位置にピンを置く
                        let pin = MKPointAnnotation()
                        pin.coordinate = targetCoordinate
                        pin.title = searchKey
                        self.mapView.addAnnotation(pin)
                        self.mapView.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        print("緯度は\(targetLatiude)")
                         //UISliderの移動とラベルの表示
                        
                        self.latitudeSlider.value = targetLatiude
                        self.longitudeSlider.value = targetLongitude
                        self.latitudeLabel.text = "緯度は\(targetLatiude)です"
                        self.longitudeLabel.text = "経度は\(targetLongitude)です"
                    }
                }
            }
            
        })
        return true   //geocoder.geocodeAddressString の戻り値
        
    }

    @IBAction func latitudeSlider(_ sender: UISlider) {
        latitudeValue = Float(sender.value)
        latitudeLabel.text = "緯度は\(latitudeValue!)です"
        print(Double(latitudeValue!))
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(latitudeValue!),Double(longitudeValue!))
        self.mapView.region = MKCoordinateRegion(center: location, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
    }
    
    @IBAction func longitudeSlider(_ sender: UISlider) {
        longitudeValue = Float(sender.value)
        longitudeLabel.text = "経度は\(longitudeValue!)です"
        print(Double(longitudeValue!))
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(latitudeValue!),Double(longitudeValue!))
        self.mapView.region = MKCoordinateRegion(center: location, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
    }
    @IBAction func decideButton(_ sender: Any) {
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(latitudeValue!), Double(longitudeValue!))
        mapView.region = MKCoordinateRegion(center: location, latitudinalMeters: 5000.0, longitudinalMeters: 5000.0)
    }
    @IBAction func changeMapStyleButton(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .satellite
        } else if mapView.mapType == .satellite {
            mapView.mapType = .hybrid
        } else if mapView.mapType == .hybrid {
            mapView.mapType = .satelliteFlyover
        } else if mapView.mapType == .satelliteFlyover {
            mapView.mapType = .hybridFlyover
        } else if mapView.mapType == .hybridFlyover {
            mapView.mapType = .mutedStandard
        } else {
            mapView.mapType = .standard
        }
    }
    
    

}

