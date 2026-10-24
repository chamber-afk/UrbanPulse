//
//  HomeViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 18/09/26.
//

import UIKit

class HomeViewController: BaseViewController {

    private var collectionView: UICollectionView!
    private let viewModel = HomeViewModel()
    private let refreshControl = UIRefreshControl()

    private var heroEvents: [Event] = []
    private var trendingEvents: [Event] = []
    private var gridEvents: [Event] = []

    private enum Section: Int, CaseIterable {
        case hero
        case categories
        case trending
        case eventsGrid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupCollectionView()
        setupCitySelector()
        bindViewModel()

        Task {
            await viewModel.loadEvents()
        }
    }

    // MARK: - City Selector

    private func setupCitySelector() {
        updateCityButtonTitle()
    }

    private func updateCityButtonTitle() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: viewModel.selectedCity,
            style: .plain,
            target: self,
            action: #selector(cityButtonTapped)
        )
    }

    @objc private func cityButtonTapped() {
        let sheet = UIAlertController(title: "Choose a City", message: nil, preferredStyle: .actionSheet)

        for city in viewModel.availableCities {
            sheet.addAction(UIAlertAction(title: city, style: .default) { [weak self] _ in
                self?.viewModel.selectCity(city)
                self?.updateCityButtonTitle()
            })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(sheet, animated: true)
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            Task { @MainActor in
                switch state {
                case .idle:
                    break

                case .loading:
                    self.showLoading()

                case .loaded:
                    self.heroEvents = self.viewModel.heroEvents
                    self.trendingEvents = self.viewModel.trendingEvents
                    self.gridEvents = self.viewModel.gridEvents
                    self.hideLoading()
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()

                case .error(let error):
                    self.heroEvents = []
                    self.trendingEvents = []
                    self.gridEvents = []
                    self.hideLoading()
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                    self.showErrorAlert(message: error.userMessage)
                }
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Collection View Setup

    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        collectionView.register(HeroBannerCell.self, forCellWithReuseIdentifier: HeroBannerCell.reuseIdentifier)
        collectionView.register(CategoryPillCell.self, forCellWithReuseIdentifier: CategoryPillCell.reuseIdentifier)
        collectionView.register(EventCardCell.self, forCellWithReuseIdentifier: EventCardCell.reuseIdentifier)
        collectionView.register(TrendingEventCell.self, forCellWithReuseIdentifier: TrendingEventCell.reuseIdentifier)  
        collectionView.register(
            SectionHeaderView.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.loadEvents()
        }
    }

    // MARK: - Layout

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .hero:
                return self.makeHeroSection()
            case .categories:
                return self.makeCategoriesSection()
            case .trending:
                return self.makeTrendingSection()
            case .eventsGrid:
                return self.makeGridSection()
            }
        }
    }

    private func makeHeroSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(180)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12) //padding of each section
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging //perpendicular to main contoller scroll direction
        return section
    }

    private func makeCategoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(36))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(36)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 12, trailing: 12)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    private func makeTrendingSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(190), heightDimension: .absolute(280)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 12, trailing: 12)
        section.interGroupSpacing = 14
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func makeGridSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220)),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .hero:
            return heroEvents.count
        case .categories:
            return viewModel.categories.count
        case .trending:
            return trendingEvents.count
        case .eventsGrid:
            return gridEvents.count
        case .none:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .hero:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroBannerCell.reuseIdentifier, for: indexPath) as? HeroBannerCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: heroEvents[indexPath.item])
            return cell

        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryPillCell.reuseIdentifier, for: indexPath) as? CategoryPillCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: viewModel.categories[indexPath.item])
            return cell

        case .trending:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingEventCell.reuseIdentifier, for: indexPath) as? TrendingEventCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: trendingEvents[indexPath.item])
            return cell

        case .eventsGrid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCardCell.reuseIdentifier, for: indexPath) as? EventCardCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: gridEvents[indexPath.item])
            return cell

        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        

        switch Section(rawValue: indexPath.section) {
        case .trending:
            header.configure(title: "Trending")

        case .eventsGrid:
            header.configure(title: "Events")

        default:
            break
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        switch Section(rawValue: indexPath.section) {
        case .hero:
            let detailVC = EventDetailViewController(event: heroEvents[indexPath.item])
            navigationController?.pushViewController(detailVC, animated: true)

        case .trending:
            let detailVC = EventDetailViewController(event: trendingEvents[indexPath.item])
            navigationController?.pushViewController(detailVC, animated: true)

        case .eventsGrid:
            let detailVC = EventDetailViewController(event: gridEvents[indexPath.item])
            navigationController?.pushViewController(detailVC, animated: true)

        case .categories:
            let category = viewModel.categories[indexPath.item]
            let searchVC = SearchViewController(initialCategory: category)
            navigationController?.pushViewController(searchVC, animated: true)

        case .none:
            return
        }
    }
}
