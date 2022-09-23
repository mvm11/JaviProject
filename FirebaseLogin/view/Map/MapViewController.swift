import UIKit
import MapKit

class MapViewController: UITabBarController, MKMapViewDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.delegate = self
        let coordinate = CLLocationCoordinate2D(latitude: 4.784477, longitude: -74.029529)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
    }
    
}

