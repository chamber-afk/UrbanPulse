//
//  TicketWalletViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 23/09/26.
//

import UIKit

class TicketWalletViewController: BaseViewController {

    private var tableView: UITableView!
    private let viewModel = TicketWalletViewModel()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No tickets booked yet"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallet"
        setupTableView()
        setupEmptyStateLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadTickets()
        tableView.reloadData()
        emptyStateLabel.isHidden = !viewModel.tickets.isEmpty
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DigitalPassCell.self, forCellReuseIdentifier: DigitalPassCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyStateLabel() {
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension TicketWalletViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tickets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DigitalPassCell.reuseIdentifier, for: indexPath) as? DigitalPassCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.tickets[indexPath.row])
        return cell
    }
}

extension TicketWalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticket = viewModel.tickets[indexPath.row]
        let qrVC = QRDetailViewController(ticket: ticket)
        qrVC.modalPresentationStyle = .pageSheet
        present(qrVC, animated: true)
    }
}
