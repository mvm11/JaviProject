import UIKit
import MapKit

class MapViewController: UITabBarController, CLLocationManagerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        let coordinate = CLLocationCoordinate2D(latitude: 4.784477, longitude: -74.029529)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
    }
    
}

