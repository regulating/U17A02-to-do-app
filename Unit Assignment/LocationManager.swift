// LocationManager.swift
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastKnownLocation: CLLocation?
    @Published var locationError: Error?
    @Published var isUpdatingLocation: Bool = false

    override init() {
        self.authorizationStatus = CLLocationManager.authorizationStatus()
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocationPermission() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // request permission
        case .restricted, .denied:
            print("location access is restricted or denied.")
            DispatchQueue.main.async {
                self.authorizationStatus = self.manager.authorizationStatus // update status
            }
        case .authorizedWhenInUse, .authorizedAlways:
            print("location access already granted.")
            DispatchQueue.main.async {
                self.authorizationStatus = self.manager.authorizationStatus // update status
            }
        @unknown default:
            print("unknown location authorization status.")
            DispatchQueue.main.async {
                self.authorizationStatus = self.manager.authorizationStatus // update status
            }
        }
    }

    func startUpdatingLocation() {
        if self.authorizationStatus == .authorizedWhenInUse || self.authorizationStatus == .authorizedAlways {
            DispatchQueue.main.async {
                self.isUpdatingLocation = true // set updating flag
                self.locationError = nil // clear error
            }
            manager.startUpdatingLocation() // start location updates
        } else {
            requestLocationPermission() // request permission if needed
        }
    }

    func requestSingleLocationUpdate() {
        if self.authorizationStatus == .authorizedWhenInUse || self.authorizationStatus == .authorizedAlways {
            DispatchQueue.main.async {
                self.isUpdatingLocation = true // set updating flag
                self.locationError = nil // clear error
            }
            manager.requestLocation() // request single update
        } else {
            requestLocationPermission() // request permission if needed
        }
    }

    func stopUpdatingLocation() {
        DispatchQueue.main.async {
            self.isUpdatingLocation = false // clear updating flag
        }
        manager.stopUpdatingLocation() // stop location updates
    }

    // MARK: - CLLocationManagerDelegate Methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus // update authorization status
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            guard let newLocation = locations.last else { return }
            self.lastKnownLocation = newLocation // update last known location
            self.locationError = nil // clear error
            print("updated location: \(newLocation.coordinate)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error // set location error
            self.isUpdatingLocation = false // clear updating flag
            print("failed to get location: \(error.localizedDescription)")
            if let clError = error as? CLError, clError.code == .denied {
                print("user denied location services during this session.")
                self.authorizationStatus = CLLocationManager.authorizationStatus() // update authorisation status
            }
        }
    }
}
