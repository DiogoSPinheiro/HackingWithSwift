//
//  ViewController.swift
//  Project16
//
//  Created by Diogo Santiago Pinheiro on 05/03/22.
//

import UIKit
import MapKit

class ViewController: UIViewController {
	
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(changeMapStyle))
		
		let brazil = Capital(title: "Sao Paulo", link: "Sao_Paulo", coordinate: CLLocationCoordinate2D(latitude: -23.533773, longitude: -46.625290), info: "This is the most populous city in Brazil")
		let london = Capital(title: "London", link: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Founded a thousand years ago")
		let paris = Capital(title: "Paris", link: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
		let rome = Capital(title: "Rome", link: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
		let washington = Capital(title: "Washington DC", link: "Washington,_D.C.", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself")
		
		mapView.addAnnotations([brazil, london, paris, rome, washington])
	}
	
	@objc func changeMapStyle() {
		let alert = UIAlertController(title: "Change Map Style", message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Standart", style: .default) { [weak self] _ in
			self?.mapView.mapType = .standard
		})
		alert.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
			self?.mapView.mapType = .hybrid
		})
		alert.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { [weak self] _ in
			self?.mapView.mapType = .hybridFlyover
		})
		alert.addAction(UIAlertAction(title: "Muted Standard", style: .default) { [weak self] _ in
			self?.mapView.mapType = .mutedStandard
		})
		alert.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
			self?.mapView.mapType = .satellite
		})
		alert.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { [weak self] _ in
			self?.mapView.mapType = .satelliteFlyover
		})
		present(alert, animated: true)
	}
	
}

extension ViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is Capital else { return nil }
		let id = "Capital"
		
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
		
		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
			annotationView?.canShowCallout = true
			
			(annotationView as? MKPinAnnotationView)?.pinTintColor = .blue
			
			let btn = UIButton(type: .detailDisclosure)
			btn.tag = 1
			let btn2 = UIButton(type: .detailDisclosure)
			btn2.tag = 2
			btn2.setImage(UIImage(systemName: "book"), for: .normal)
			
			annotationView?.rightCalloutAccessoryView = btn
			annotationView?.leftCalloutAccessoryView = btn2
		} else {
			annotationView?.annotation = annotation
		}
		
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		guard let capital = view.annotation as? Capital else { return }
		
		if control.tag == 1 {
			let placeName = capital.title
			let placeInfo = capital.info
			
			let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Ok", style: .default))
			present(ac, animated: true)
		} else if control.tag == 2 {
			if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
				webViewController.url = "https://en.wikipedia.org/wiki/\(capital.link)"
				navigationController?.pushViewController(webViewController, animated: true)
			}
		}
	}
}

