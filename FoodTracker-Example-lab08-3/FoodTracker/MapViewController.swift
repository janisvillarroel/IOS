//
//  MapViewController.swift
//  FoodTracker
//
//  Created by jbian on 11/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var test:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera Zoom
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        // Geolocation
        let location:CLLocationCoordinate2D =
            CLLocationCoordinate2D(latitude: 45.612125, longitude: 22.948280)
        // ADD MARKER
        let theRegion:MKCoordinateRegion =
            MKCoordinateRegionMake(location, theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        // Add Pin and Label
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = "The Location"
        anotation.subtitle = "This is the location !!!"
        mapView.addAnnotation(anotation)
        // end put Marker

       /*
        Alamofire.request("http://api.androidhive.info/contacts/").responseData { (resData) -> Void in
            print(resData.result.value!)
            let strOutput = String(data : resData.result.value!, encoding : String.Encoding.utf8)
            print(strOutput)
        }*/
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
