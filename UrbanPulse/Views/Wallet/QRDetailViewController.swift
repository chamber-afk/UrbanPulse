//
//  QRDetailViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit

class QRDetailViewController: UIViewController {

    private let ticket: Ticket

    private let qrImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(ticket: Ticket) {
        self.ticket = ticket
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        populate()
    }

    private func setupLayout() {
        view.addSubview(qrImageView)
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            qrImageView.widthAnchor.constraint(equalToConstant: 220),
            qrImageView.heightAnchor.constraint(equalToConstant: 220),

            infoLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func populate() {
        qrImageView.image = QRCodeGenerator.generate(from: ticket.qrCodeData)
        infoLabel.text = "\(ticket.eventName)\n\(ticket.venueName)\nDate: \(ticket.eventDate)\nTicket ID: \(ticket.id)"
    }
}
