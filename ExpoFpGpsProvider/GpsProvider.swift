import ExpoFpCommon
import Foundation
import CoreLocation

public class GpsProvider : NSObject, LocationProvider, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager? = nil
    
    private var lDelegate: ExpoFpCommon.LocationProviderDelegate? = nil
    
    private var status: CLAuthorizationStatus = .denied
    
    public var delegate: ExpoFpCommon.LocationProviderDelegate? {
        get { lDelegate }
        set(newDelegate) {
            lDelegate = newDelegate
        }
    }
    
    public func start() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.activityType = .fitness
            self.locationManager?.distanceFilter = .zero
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    public func stop() {
        self.locationManager?.delegate = nil
        self.locationManager?.stopUpdatingLocation()
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
        if(status == .authorizedAlways || status == .authorizedWhenInUse || status == .notDetermined){
            stop()
            Thread.sleep(forTimeInterval: 1.0)
            start()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
}
