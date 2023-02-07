import ExpoFpCommon
import Foundation
import CoreLocation

public class GpsProvider : NSObject, LocationProvider, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager? = nil
    
    private var lDelegate: ExpoFpCommon.LocationProviderDelegate? = nil
    
    private var status: CLAuthorizationStatus = .denied
    
    private var started = false
    
    public var delegate: ExpoFpCommon.LocationProviderDelegate? {
        get { lDelegate }
        set(newDelegate) {
            lDelegate = newDelegate
        }
    }
    
    public func start() {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
        self.locationManager = manager
       
    }
    
    public func stop() {
        if let manager = self.locationManager {
            stopUpdate(manager)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("POINT1: didUpdateLocations")
        
        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate
        else { return }

        let dloc = ExpoFpCommon.Location(latitude: loc.latitude, longitude: loc.longitude, angle: nil)
        print("POINT1.1 dloc:")
        print(dloc)
        
        if let dlg = delegate {
            dlg.didUpdateLocation(location: dloc)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("POINT2 didFailWithError status:")
        print(status)
        
        print("POINT2.1 didFailWithError error:")
        print(error)
        
        if(status == .authorizedAlways || status == .authorizedWhenInUse || status == .notDetermined){
            stopUpdate(manager)
            Thread.sleep(forTimeInterval: 1.0)
            startUpdate(manager)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("POINT3 didChangeAuthorization status:")
        print(status)
        
        self.status = status
        if(status == .denied || status == .restricted){
            stopUpdate(manager)
        }
        else if(status == .authorizedAlways || status == .authorizedWhenInUse){
            startUpdate(manager)
        }
    }
    
    private func startUpdate(_ manager: CLLocationManager){
        print("POINT4: startUpdate")
        
        if(self.started){
            return
        }
        
        self.started = true
        
        if CLLocationManager.locationServicesEnabled() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .fitness
            manager.distanceFilter = .zero
            manager.startUpdatingLocation()
        }
    }
    
    private func stopUpdate(_ manager: CLLocationManager){
        print("POINT5: stopUpdate")
        
        if(!self.started){
            return
        }
        
        self.started = false
        
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
}
