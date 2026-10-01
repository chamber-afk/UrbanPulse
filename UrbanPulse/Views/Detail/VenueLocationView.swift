//
//  VenueLocationView.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit
import MapKit

class VenueLocationView: UIView {

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(mapView)
        addSubview(addressLabel)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 160),

            addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with venue: Venue?) {
        guard let venue,
              let lat = Double(venue.location?.latitude ?? ""),
              let lon = Double(venue.location?.longitude ?? "") else {
            addressLabel.text = "Venue location unavailable"
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 800,
            longitudinalMeters: 800
        )
        mapView.setRegion(region, animated: false)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = venue.name
        mapView.addAnnotation(pin)

        var addressText = venue.name
        if let line1 = venue.address?.line1 {
            addressText += "\n\(line1)"
        }
        if let city = venue.city?.name {
            addressText += ", \(city)"
        }
        addressLabel.text = addressText
    }
}
