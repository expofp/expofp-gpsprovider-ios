import ExpoFpCommon
import Foundation
import CoreLocation

public class GpsProvider : NSObject, LocationProvider, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var lDelegate: ExpoFpCommon.LocationProviderDelegate? = nil
    
    private var started = false
    
    public var delegate: ExpoFpCommon.LocationProviderDelegate? {
        get { lDelegate }
        set(newDelegate) {
            lDelegate = newDelegate
            startUpdate(locationManager)
        }
    }
    
    public func start(_ inBackground:Bool) {
        if(self.started){
            return
        }
        
        self.started = true
        startUpdate(locationManager)
    }
    
    public func stop() {
        
        if(!self.started){
            return
        }

        self.started = false
        stopUpdate(locationManager)
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
        if(manager.authorizationStatus == .notDetermined){
            stopUpdate(manager)
            Thread.sleep(forTimeInterval: 1.0)
            startUpdate(manager)
        }
    }
    
    private func startUpdate(_ manager: CLLocationManager){
        if(!started || delegate == nil){
            return
        }
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .fitness
            manager.distanceFilter = .zero
            manager.startUpdatingLocation()
        }
    }
    
    private func stopUpdate(_ manager: CLLocationManager){
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
}
