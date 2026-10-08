//
//  SearchViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 23/09/26.
//

import UIKit

class SearchViewController: BaseViewController {

    private let viewModel = SearchViewModel()
    private var tableView: UITableView!
    private var searchController: UISearchController!
    private var initialCategory: String?
    
    init(initialCategory : String? = nil){
        self.initialCategory = initialCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var results: [Event] = []

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for events by name"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.text = ""
        searchController.isActive = false
        viewModel.searchTextDidChange("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setupTableView()
        setupSearchController()
        setupEmptyStateLabel()
        bindViewModel()
        
        if let initialCategory {
            viewModel.selectCategory(initialCategory)
        }
    }

    // MARK: - Search Controller

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search events, artists, venues"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    // MARK: - Table View

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListCell.self, forCellReuseIdentifier: EventListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 86

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
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            Task { @MainActor in
                switch state {
                case .idle:
                    self.results = []
                    self.hideLoading()
                    self.tableView.reloadData()
                    self.emptyStateLabel.text = "Search for events by name"
                    self.emptyStateLabel.isHidden = false

                case .loading:
                    self.showLoading()
                    self.emptyStateLabel.isHidden = true

                case .loaded(let events):
                    self.results = events
                    self.hideLoading()
                    self.tableView.reloadData()
                    self.emptyStateLabel.text = "No events found"
                    self.emptyStateLabel.isHidden = !events.isEmpty ? true : false

                case .error:
                    self.results = []
                    self.hideLoading()
                    self.tableView.reloadData()
                    self.emptyStateLabel.text = "Something went wrong. Try again."
                    self.emptyStateLabel.isHidden = false
                }
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.searchTextDidChange(text)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EventListCell.reuseIdentifier,
            for: indexPath
        ) as? EventListCell else {
            print("DEBUG: cell cast FAILED at row \(indexPath.row)")
            return UITableViewCell()
        }
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = results[indexPath.row]
        let detailVC = EventDetailViewController(event: event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
