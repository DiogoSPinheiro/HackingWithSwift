//
//  ViewController.swift
//  Project25
//
//  Created by Diogo Santiago Pinheiro on 06/03/22.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {

	var images = [UIImage]()
	
	var peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
	var mcSession: MCSession?
	var mcAdvertiserAssistant: MCAdvertiserAssistant!
	var connectedDevices = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Selfie Share"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
			UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showConnectedDevices))
		]
		
		mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
		
		mcSession?.delegate = self
	}
	
	@objc func showConnectedDevices() {
		let ac = UIAlertController(title: "Devices", message: connectedDevices.joined(separator: ", "), preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Ok", style: .default))
		present(ac, animated: true)
	}
	
	@objc func showConnectionPrompt() {
		let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
		ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	
	func startHosting(action: UIAlertAction) {
		guard let mcSession = mcSession else { return }
		
		mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "test-project25", discoveryInfo: nil, session: mcSession)
		mcAdvertiserAssistant?.start()
	}
	
	func joinSession(action: UIAlertAction) {
		guard let mcSession = mcSession else { return }
		
		let mcBrowser = MCBrowserViewController(serviceType: "test-project25", session: mcSession)
		mcBrowser.delegate = self
		present(mcBrowser, animated: true)
	}
					 
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated: true)
	}
}

extension ViewController: UINavigationControllerDelegate {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
		
		if let imageView =  cell.viewWithTag(1000) as? UIImageView {
			imageView.image = images[indexPath.item]
		}
		
		return cell
	}
}

extension ViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		
		images.insert(image, at: 0)
		collectionView.reloadData()
		
		guard let mcSession = mcSession else { return }
		
		let image64String = image.pngData()?.base64EncodedString()
		
		if let image64String = image64String,
		   mcSession.connectedPeers.count > 0 {
			let image = Image(name: UUID().uuidString, image: image64String)
			do {
				let imageData = try JSONEncoder().encode(image)
				try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
			} catch {
				let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "OK", style: .default))
				present(ac, animated: true)
			}
		}
	}
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
		
	}
	
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
		
	}
	
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
		
	}
	
	func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
		dismiss(animated: true)
	}
	
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
		case .connected:
			print("Connected: \(peerID.displayName)")
			connectedDevices.append(peerID.displayName)
		case .connecting:
			print("Connected: \(peerID.displayName)")
		case .notConnected:
			print("Not connected: \(peerID.displayName)")
			DispatchQueue.main.async {
				let alert = UIAlertController(title: "User disconnected", message: "User \(peerID.displayName) disconects", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default))
				self.present(alert, animated: true)
			}
		@unknown default:
			print("Unknown state received: \(peerID.displayName)")
		}
	}
	
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		DispatchQueue.main.async { [weak self] in
			
			do {
				let imageObj = try JSONDecoder().decode(Image.self, from: data)
				if let imageBase64 = Data(base64Encoded: imageObj.image),
				   let image = UIImage(data: imageBase64) {
					self?.images.insert(image, at: 0)
				}
				print(imageObj.name)
				self?.collectionView.reloadData()
			} catch {
				let alert = UIAlertController(title: "Error", message: "Decoding", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default))
				self?.present(alert, animated: true)
			}
		}
	}
}
