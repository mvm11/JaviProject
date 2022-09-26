import UIKit
import MapKit
import CoreLocationUI
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    

    let annotationLocations = [
        ["title": "coordinada1", "latitude": 4.782013, "longitude": -74.046487],
        ["title": "coordinada2", "latitude": 4.813308, "longitude": -74.099955],
        ["title": "coordinada3", "latitude": 4.772404, "longitude": -74.107858],
        ["title": "coordinada4", "latitude": 4.744963, "longitude": -74.091796],
        ["title": "coordinada5", "latitude": 4.743185, "longitude": -74.035706],
        ["title": "coordinada6", "latitude": 4.737863, "longitude": -74.007123],
        ["title": "coordinada7", "latitude": 4.742649, "longitude": -73.979645],
        ["title": "coordinada8", "latitude": 4.761838, "longitude": -73.974118],
        ["title": "coordinada9", "latitude": 4.784723, "longitude": -73.982998],
        ["title": "coordinada10", "latitude": 4.794183, "longitude": -74.000146],
        ["title": "coordinada11", "latitude": 4.821644, "longitude": -74.008413],
        ["title": "coordinada12", "latitude": 4.823475, "longitude": -74.039340],
        ["title": "coordinada13", "latitude": 4.823780, "longitude": -74.052813],
        ["title": "coordinada14", "latitude": 4.836290, "longitude": -74.039034],
        ["title": "coordinada15", "latitude": 4.870157, "longitude": -74.030154]
    ]
    
    let manager = CLLocationManager()
    let regionInMeters: Double = 10000

    
    fileprivate func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let coordinate = CLLocationCoordinate2D(latitude: 4.784477, longitude: -74.029529)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
        createAnnotations(locations: annotationLocations)
        
        func createAnnotations(locations: [[String: Any]]){
            
            for location in locations {
                let annotations = MKPointAnnotation()
                annotations.title = location["title"] as? String
                annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
                mapView.addAnnotation(annotations)
            }
        }
    }
    
    
    @IBAction func showUserLocation(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        checkLocationServices()
    }
    
    func centerViewOnUserLocation() {
        if let location = manager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            manager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


