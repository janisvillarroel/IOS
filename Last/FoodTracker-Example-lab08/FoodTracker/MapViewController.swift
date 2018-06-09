//
//  MapViewController.swift
//  FoodTracker
//
//  Created by Janis on 11/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -17.371673, longitude: -66.140782)
          let location2:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -17.374007, longitude:-66.137005)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        mapView.setRegion(theRegion, animated: true)
        let theRegion2:MKCoordinateRegion = MKCoordinateRegionMake(location2, theSpan)
        mapView.setRegion(theRegion2, animated: true)
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = "The Location"
        anotation.subtitle = "This is the location !!!"
        let anotation2 = MKPointAnnotation()
        anotation2.coordinate = location2
        anotation2.title = "The Location 22"
        anotation2.subtitle = "This is the location 22!!!"
        mapView.addAnnotation(anotation)
        mapView.addAnnotation(anotation2)
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector(("action:")))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var mapView: MKMapView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
