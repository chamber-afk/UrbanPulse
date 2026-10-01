//
//  BookingViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit

class BookingViewController: BaseViewController {

    private let viewModel: BookingViewModel
    private var countLabels: [SeatCategory: UILabel] = [:]

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Booking", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(event: Event) {
        self.viewModel = BookingViewModel(event: event)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Tickets"
        setupLayout()
        updateTotalLabel()
    }

    private func setupLayout() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false

        for category in [SeatCategory.standard, .premium, .vip] {
            stack.addArrangedSubview(makeCategoryRow(for: category))
        }

        view.addSubview(stack)
        view.addSubview(totalLabel)
        view.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            totalLabel.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -12),
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    private func makeCategoryRow(for category: SeatCategory) -> UIView {
        let row = UIView()

        let nameLabel = UILabel()
        nameLabel.text = "\(category.rawValue.capitalized) - ₹\(Int(category.basePrice))"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let minusButton = UIButton(type: .system)
        minusButton.setTitle("−", for: .normal)
        minusButton.tag = category.tagValue
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)

        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabels[category] = countLabel

        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.tag = category.tagValue
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)

        [nameLabel, minusButton, countLabel, plusButton].forEach { row.addSubview($0) }

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            plusButton.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            plusButton.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),

            countLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -12),
            countLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 24),

            minusButton.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -12),
            minusButton.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),

            row.heightAnchor.constraint(equalToConstant: 30)
        ])

        return row
    }

    @objc private func plusTapped(_ sender: UIButton) {
        guard let category = SeatCategory.from(tag: sender.tag) else { return }
        viewModel.increment(category)
        countLabels[category]?.text = "\(viewModel.quantities[category] ?? 0)"
        updateTotalLabel()
    }

    @objc private func minusTapped(_ sender: UIButton) {
        guard let category = SeatCategory.from(tag: sender.tag) else { return }
        viewModel.decrement(category)
        countLabels[category]?.text = "\(viewModel.quantities[category] ?? 0)"
        updateTotalLabel()
    }

    private func updateTotalLabel() {
        totalLabel.text = "Total: ₹\(Int(viewModel.totalPrice))"
    }

    @objc private func confirmTapped() {
        guard let _ = viewModel.confirmBooking() else {
            let alert = UIAlertController(title: "Select at least one ticket", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let alert = UIAlertController(title: "Booking Confirmed!", message: "Your ticket has been saved to your Wallet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
