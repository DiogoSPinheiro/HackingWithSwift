//
//  ViewController.swift
//  Project22
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet var distanceReading: UILabel!
	@IBOutlet var indicativeCircle: UIImageView!
	
	var locationManager: CLLocationManager?
	var firstTime = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.requestAlwaysAuthorization()
		
		view.backgroundColor = .gray
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if manager.authorizationStatus == .authorizedAlways {
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				if CLLocationManager.isRangingAvailable() {
					startScanning()
				}
			}
		}
	}
	
	func startScanning() {
		let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
		let beaconRegion = CLBeaconRegion(uuid: uuid, major: 456, identifier: "MyBeacon")
		
		locationManager?.startMonitoring(for: beaconRegion)
		locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
	}
	
	func update(distance: CLProximity) {
		UIView.animate(withDuration: 1, animations: {
			switch distance {
			case .immediate:
				self.view.backgroundColor = .red
				self.distanceReading.text  = "RIGHT HERE"
				self.indicativeCircle.transform = CGAffineTransform(scaleX: 2, y: 2)
			case .near:
				self.view.backgroundColor = .orange
				self.distanceReading.text  = "NEAR"
				self.indicativeCircle.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

			case .far:
				self.view.backgroundColor = .blue
				self.distanceReading.text  = "FAR"
				self.indicativeCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
			default:
				self.view.backgroundColor = .gray
				self.indicativeCircle.isHidden = true
				self.distanceReading.text = "UNKWNOW"
			}
			
		})
	}
	
	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		if let beacon = beacons.first {
			
			if !firstTime {
				let alert = UIAlertController(title: "First time", message: "Your beacon was found for the first time ^^", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
					self?.indicativeCircle.isHidden = false
				})
				present(alert, animated: true)
			}
			
			firstTime = true
			update(distance: beacon.proximity)
			
		} else {
			update(distance: .unknown)
		}
	}
}

