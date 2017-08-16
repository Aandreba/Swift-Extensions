import Foundation
import UIKit
import CoreLocation
import MapKit

extension Bool {
    init?(numericRepresentation: Int){
        if numericRepresentation == 0 {
            self = false
        } else if numericRepresentation == 1 {
            self = true
        } else {
            return nil
        }
    }
}

func imageFromInternet(contentsOfURL: NSURL)->UIImage {
        let data = NSData(contentsOfURL: contentsOfURL)
        return UIImage(data: data!)!
    }

extension String {
    func substractFirst(n:Int)->String{
        return String(self.characters.dropLast(n))
    }
}

extension NSData {
    func substractFirst(n:Int)->NSData{
        var string = NSString(data: self, encoding: NSUTF8StringEncoding) as! String
        string = String(string.characters.dropFirst(n))
        return string.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    func substractLast(n:Int)->NSData{
        var string = NSString(data: self, encoding: NSUTF8StringEncoding) as! String
        string = String(string.characters.dropLast(n))
        return string.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}

func centerMapOnLocation(mapView: MKMapView,location: CLLocation, regionRadius: Double = 200)
{
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
}

class GMPlacemark:NSObject {
    public private(set) var streetNumber : Int?
    public private(set) var route : String
    public private(set) var locality : String
    public private(set) var administrativeArea : [Int:String]
    public private(set) var country : String
    public private(set) var postalCode : String
    public private(set) var formattedAddress : String
    
    init(location:CLLocation) {
        let url:NSURL = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.coordinate.latitude),\(location.coordinate.longitude)&sensor=true")!
        let data = NSData(contentsOfURL: url)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        var number = Bool()
        if (jsonResult!["results"]![0]["address_components"]!![0]["types"]!![0] as! String) == "street_number" {
            number = true
        } else {
            number = false
        }
        if number == true {
            self.streetNumber = (jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! NSString).integerValue
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![6]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String]
        } else {
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String]
        }
    }
    
    init(address:String) {
        let url:NSURL = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=true")!
        let data = NSData(contentsOfURL: url)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        var number = Bool()
        if (jsonResult!["results"]![0]["address_components"]!![0]["types"]!![0] as! String) == "street_number" {
            number = true
        } else {
            number = false
        }
        if number == true {
            self.streetNumber = (jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! NSString).integerValue
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![6]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String]
        } else {
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String]
        }
    }
    
    
    init(coordinate:CLLocationCoordinate2D) {
        let url:NSURL = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)&sensor=true")!
        let data = NSData(contentsOfURL: url)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        var number = Bool()
        if (jsonResult!["results"]![0]["address_components"]!![0]["types"]!![0] as! String) == "street_number" {
            number = true
        } else {
            number = false
        }
        if number == true {
            self.streetNumber = (jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! NSString).integerValue
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![6]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String]
        } else {
            self.formattedAddress = jsonResult!["results"]![0]["formatted_address"] as! String
            self.country = jsonResult!["results"]![0]["address_components"]!![4]["long_name"] as! String
            self.locality = jsonResult!["results"]![0]["address_components"]!![1]["long_name"] as! String
            self.postalCode = jsonResult!["results"]![0]["address_components"]!![5]["long_name"] as! String
            self.route = jsonResult!["results"]![0]["address_components"]!![0]["long_name"] as! String
            self.administrativeArea = [0: "", 1 : jsonResult!["results"]![0]["address_components"]!![3]["long_name"] as! String, 2: jsonResult!["results"]![0]["address_components"]!![2]["long_name"] as! String]
        }
    }
    
}

class IPLocation:NSObject {
    var coordinate:CLLocationCoordinate2D
    var clplacemark:CLPlacemark?
    var gmplacemark:GMPlacemark?
    
    override init() {
        let locationManager = CLLocationManager()
        self.coordinate = (locationManager.location?.coordinate)!
        self.clplacemark = locationManager.location?.placemark
        self.gmplacemark = GMPlacemark(location: locationManager.location!)
    }
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.clplacemark = coordinate.placemark
        self.gmplacemark = GMPlacemark(coordinate: coordinate)
    }
    init(location:CLLocation) {
        self.coordinate = location.coordinate
        self.clplacemark = location.placemark
        self.gmplacemark = GMPlacemark(location: location)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
extension Float {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return Float(round(self * divisor) / divisor)
    }
}

extension NSData {
    var decodedJSON : NSArray? {
        var ret : NSArray?
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(self, options: []) as? NSArray {
                ret = jsonResult
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return ret
    }
    
    var decodedJSONAsDic : NSDictionary? {
        var ret : NSDictionary?
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(self, options: []) as? NSDictionary {
                ret = jsonResult
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return ret
    }
}

extension CLLocationCoordinate2D {
    var placemark:CLPlacemark?{
        var pm:CLPlacemark?
        var location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                pm = nil
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                pm = placemarks![0] as! CLPlacemark
            } else {
                pm = nil
                print("Problem with the data received from geocoder")
            }
        })
        return pm
    }
    
    var googlePlacemark:GMPlacemark {
        return GMPlacemark(coordinate: self)
    }
    
    var location:CLLocation { return CLLocation(latitude: self.latitude, longitude: self.longitude) }
    
    var arrayPlacemark:[String:String] {
        let slf = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let url:NSURL = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(slf.coordinate.latitude),\(slf.coordinate.longitude)&sensor=true")!
        let data = NSData(contentsOfURL: url)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        var arr = jsonResult!["results"]![0]["address_components"] as! [AnyObject]
        var dt = [String:String]()
        for things in arr {
            var array = things as! [String:NSObject]
            var types = array["types"] as! [String]
            dt[types[0]] = array["long_name"] as! String
        }
        dt["formatted_address"] = jsonResult!["results"]![0]["formatted_address"] as! String
        return dt
        
    }
    
}
extension CLLocation {
    func createPointAnnotation(name:String, subtitle:String?)->MKPointAnnotation{
        let ann = MKPointAnnotation()
        ann.coordinate = self.coordinate
        ann.title = name
        ann.subtitle = subtitle
        return ann
    }
    
    var placemark:CLPlacemark?{
        var pm:CLPlacemark?
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                pm = nil
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                pm = placemarks![0] as! CLPlacemark
            } else {
                pm = nil
                print("Problem with the data received from geocoder")
            }
        })
        return pm
    }
    var arrayPlacemark:[String:String] {
        let url:NSURL = NSURL(string: "http://maps.googleapis.com/maps/api/geocode/json?latlng=\(self.coordinate.latitude),\(self.coordinate.longitude)&sensor=true")!
        let data = NSData(contentsOfURL: url)
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
        var arr = jsonResult!["results"]![0]["address_components"] as! [AnyObject]
        var dt = [String:String]()
        for things in arr {
            var array = things as! [String:NSObject]
            var types = array["types"] as! [String]
            dt[types[0]] = array["long_name"] as! String
        }
        dt["formatted_address"] = jsonResult!["results"]![0]["formatted_address"] as! String
        return dt
        
    }
    
    var googlePlacemark:GMPlacemark {
        return GMPlacemark(location: self)
    }
}


func determineMyCurrentLocation(locationManager:CLLocationManager, vc:CLLocationManagerDelegate) {
    locationManager.delegate = vc
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
}

extension CLLocationCoordinate2D {
    var array:[CLLocationDegrees]{
        return [self.latitude, self.longitude]
    }
}

extension MKMapView {
    func route(delegate: MKMapViewDelegate, sourceLocation:CLLocationCoordinate2D, destinationLocation:CLLocationCoordinate2D){
        self.delegate = delegate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = sourceLocation.googlePlacemark.formattedAddress
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = destinationLocation.googlePlacemark.formattedAddress
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .Automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
}



