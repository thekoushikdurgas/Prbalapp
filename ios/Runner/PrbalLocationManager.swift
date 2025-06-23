import CoreLocation
import UIKit

class PrbalLocationManager: NSObject {
    
    static let shared = PrbalLocationManager()
    
    private let locationManager = CLLocationManager()
    private var locationUpdateCallback: ((CLLocation) -> Void)?
    private var authorizationCallback: ((CLAuthorizationStatus) -> Void)?
    private var errorCallback: ((Error) -> Void)?
    
    private var isMonitoringLocation = false
    private var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    // MARK: - Public Methods
    
    func requestLocationPermission(completion: @escaping (CLAuthorizationStatus) -> Void) {
        authorizationCallback = completion
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            completion(locationManager.authorizationStatus)
        }
    }
    
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.failure(LocationError.locationServicesDisabled))
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse || 
              locationManager.authorizationStatus == .authorizedAlways else {
            completion(.failure(LocationError.permissionDenied))
            return
        }
        
        // Return cached location if recent enough (less than 5 minutes old)
        if let lastLocation = lastKnownLocation,
           Date().timeIntervalSince(lastLocation.timestamp) < 300 {
            completion(.success(lastLocation))
            return
        }
        
        // Request new location
        locationUpdateCallback = { location in
            completion(.success(location))
        }
        
        errorCallback = { error in
            completion(.failure(error))
        }
        
        locationManager.requestLocation()
    }
    
    func startLocationUpdates(completion: @escaping (CLLocation) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedWhenInUse || 
              locationManager.authorizationStatus == .authorizedAlways else {
            return
        }
        
        locationUpdateCallback = completion
        isMonitoringLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        isMonitoringLocation = false
        locationManager.stopUpdatingLocation()
        locationUpdateCallback = nil
    }
    
    func startSignificantLocationChanges() {
        guard locationManager.authorizationStatus == .authorizedAlways else {
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK: - Utility Methods
    
    func isLocationPermissionGranted() -> Bool {
        return locationManager.authorizationStatus == .authorizedWhenInUse || 
               locationManager.authorizationStatus == .authorizedAlways
    }
    
    func getLocationPermissionStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func getLastKnownLocation() -> CLLocation? {
        return lastKnownLocation
    }
    
    func calculateDistance(from location1: CLLocation, to location2: CLLocation) -> CLLocationDistance {
        return location1.distance(from: location2)
    }
    
    func formatDistance(_ distance: CLLocationDistance) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 1
        
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        return formatter.string(from: measurement)
    }
    
    // MARK: - Geofencing
    
    func startMonitoring(region: CLCircularRegion) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            debugPrint("Geofencing is not available on this device")
            return
        }
        
        guard locationManager.authorizationStatus == .authorizedAlways else {
            debugPrint("Always location permission required for geofencing")
            return
        }
        
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(region: CLCircularRegion) {
        locationManager.stopMonitoring(for: region)
    }
    
    // MARK: - Service Provider Tracking
    
    func createServiceProviderRegion(center: CLLocationCoordinate2D, 
                                   identifier: String, 
                                   radius: CLLocationDistance = 100) -> CLCircularRegion {
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func findNearbyServiceProviders(within radius: CLLocationDistance, 
                                  completion: @escaping ([ServiceProvider]) -> Void) {
        guard let currentLocation = lastKnownLocation else {
            completion([])
            return
        }
        
        // This would typically make an API call to find nearby service providers
        // For now, returning empty array as this would integrate with your backend
        completion([])
    }
}

// MARK: - CLLocationManagerDelegate

extension PrbalLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        lastKnownLocation = location
        
        // Call the callback if monitoring
        if isMonitoringLocation {
            locationUpdateCallback?(location)
        }
        
        // Log location update
        debugPrint("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("❌ Location error: \(error.localizedDescription)")
        errorCallback?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("📍 Location authorization changed: \(status.rawValue)")
        authorizationCallback?(status)
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, can start location services
            break
        case .denied, .restricted:
            // Permission denied, stop location services
            stopLocationUpdates()
        case .notDetermined:
            // Still waiting for user decision
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        debugPrint("📍 Entered region: \(region.identifier)")
        
        // Handle geofence entry - could trigger notifications or API calls
        NotificationCenter.default.post(name: .didEnterRegion, object: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        debugPrint("📍 Exited region: \(region.identifier)")
        
        // Handle geofence exit
        NotificationCenter.default.post(name: .didExitRegion, object: region)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        debugPrint("❌ Monitoring failed for region: \(region?.identifier ?? "unknown") - \(error.localizedDescription)")
    }
}

// MARK: - Location Errors

enum LocationError: Error, LocalizedError {
    case locationServicesDisabled
    case permissionDenied
    case locationUnavailable
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .locationServicesDisabled:
            return "Location services are disabled"
        case .permissionDenied:
            return "Location permission denied"
        case .locationUnavailable:
            return "Location is unavailable"
        case .timeout:
            return "Location request timed out"
        }
    }
}

// MARK: - Service Provider Model (placeholder)

struct ServiceProvider {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
    let rating: Double
    let distance: CLLocationDistance
    let category: String
    let isAvailable: Bool
}

// MARK: - Notification Names

extension Notification.Name {
    static let didEnterRegion = Notification.Name("didEnterRegion")
    static let didExitRegion = Notification.Name("didExitRegion")
    static let locationPermissionChanged = Notification.Name("locationPermissionChanged")
} 