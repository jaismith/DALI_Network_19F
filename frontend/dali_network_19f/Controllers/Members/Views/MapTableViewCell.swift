//
//  MapTableViewCell.swift
//  dali_network_19f
//
//  Created by Jai Smith on 8/14/19.
//  Copyright © 2019 Jai Smith. All rights reserved.
//

import MapKit
import UIKit
import os.log

class MapTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!

    var member: Member? {
        didSet {
            guard let member = member else {
                return
            }

            setLocation(member)
        }
    }
    var location: Location?

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        // enable autolayout
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = .flexibleHeight

        // round corners
        mapView.layer.cornerRadius = 14
        mapView.layer.masksToBounds = true

        // disable user interaction
        mapView.isUserInteractionEnabled = false
    }

    // MARK: Public Methods

    func setLocation(_ member: Member) {
        // check for location
        guard let location = member.location else {
            os_log("No location data for member %@", log: OSLog.default, type: .debug, member.name)
            self.isHidden = true
            
            return
        }

        // create CLLocationCoordinate2D
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

        // create region
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2500000, longitudinalMeters: 2500000)

        // set map region
        self.mapView.setRegion(region, animated: true)

        // create annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
    }
}
