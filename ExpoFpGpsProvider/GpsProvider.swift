import ExpoFpCommon
import Foundation
import CoreLocation

public class GpsProvider : NSObject, LocationProvider, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var lDelegate: ExpoFpCommon.LocationProviderDelegate? = nil
    
    public var delegate: ExpoFpCommon.LocationProviderDelegate? {
        get { lDelegate }
        set(newDelegate) {
            lDelegate = newDelegate
        }
    }
    
    public func start() {
        requestPermissions()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.activityType = .fitness
            locationManager.distanceFilter = .zero
            locationManager.startUpdatingLocation()
        }
    }
    
    public func stop() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate
        else { return }
        
        let dloc = ExpoFpCommon.Location(latitude: loc.latitude, longitude: loc.longitude, angle: nil)
        if let dlg = delegate {
            dlg.didUpdateLocation(location: dloc)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stop()
        Thread.sleep(forTimeInterval: 1.0)
        start()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    private func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
}
