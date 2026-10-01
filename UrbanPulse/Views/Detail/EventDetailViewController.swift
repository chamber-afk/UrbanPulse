//
//  EventDetailViewController.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit

class EventDetailViewController: BaseViewController {

    private let viewModel: EventDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About this event"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let venueTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Venue"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let venueLocationView = VenueLocationView()

    private var isBookmarked = false

    // MARK: - Init

    init(event: Event) {
        self.viewModel = EventDetailViewModel(event: event)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBookmarkButton()
        populateContent()
    }

    // MARK: - Bookmark button

    private func setupBookmarkButton() {
        updateBookmarkIcon()
    }
    
    private func updateBookmarkIcon() {
        let isBookmarked = BookmarksManager.shared.isBookmarked(viewModel.event.id)
        let iconName = isBookmarked ? "bookmark.fill" : "bookmark"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: iconName),
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
    }
    
    @objc private func bookmarkTapped() {
        BookmarksManager.shared.toggleBookmark(viewModel.event)
        updateBookmarkIcon()
    }
    
    //MARK: - Event booking button

    private let bookNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Book Now", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func bookNowTapped() {
        let bookingVC = BookingViewController(event: viewModel.event)
        navigationController?.pushViewController(bookingVC, animated: true)
    }
    
    // MARK: - Populate content with real data

    private func populateContent() {
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.formattedDate
        statusBadge.text = "  \(viewModel.statusText)  "
        priceLabel.text = viewModel.priceText
        descriptionLabel.text = viewModel.description
        venueLocationView.configure(with: viewModel.venue)

        guard let imageURL = viewModel.bannerImageURL else { return }
        Task {
            if let image = await ImageLoader.shared.loadImage(from: imageURL) {
                bannerImageView.image = image
            }
        }
    }

    // MARK: - Layout (UIScrollView + content stack)

    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(bookNowButton)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        venueLocationView.translatesAutoresizingMaskIntoConstraints = false

        // Scroll view fills the screen.
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookNowButton.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            bookNowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bookNowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bookNowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            bookNowButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        bookNowButton.addTarget(self, action: #selector(bookNowTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        [bannerImageView, titleLabel, dateLabel, statusBadge, priceLabel,
         descriptionTitleLabel, descriptionLabel, venueTitleLabel, venueLocationView].forEach {
            contentView.addSubview($0)
        }
        
        
        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 240),

            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            statusBadge.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statusBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            statusBadge.heightAnchor.constraint(equalToConstant: 22),

            dateLabel.centerYAnchor.constraint(equalTo: statusBadge.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: statusBadge.trailingAnchor, constant: 8),

            priceLabel.topAnchor.constraint(equalTo: statusBadge.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            descriptionTitleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 24),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            venueTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            venueTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            venueTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            venueLocationView.topAnchor.constraint(equalTo: venueTitleLabel.bottomAnchor, constant: 8),
            venueLocationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            venueLocationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            venueLocationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])
        
    }
}
