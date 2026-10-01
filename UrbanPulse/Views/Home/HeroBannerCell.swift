//
//  HeroBannerCell.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 23/09/26.
//

import UIKit

class HeroBannerCell: UICollectionViewCell {

    static let reuseIdentifier = "HeroBannerCell"

    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gradientOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(bannerImageView)
        bannerImageView.addSubview(gradientOverlay)
        bannerImageView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            gradientOverlay.leadingAnchor.constraint(equalTo: bannerImageView.leadingAnchor),
            gradientOverlay.trailingAnchor.constraint(equalTo: bannerImageView.trailingAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: bannerImageView.bottomAnchor),
            gradientOverlay.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: gradientOverlay.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: gradientOverlay.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: gradientOverlay.centerYAnchor)
        ])
    }

    func configure(with event: Event) {
        titleLabel.text = event.name

        bannerImageView.image = nil
        bannerImageView.alpha = 0

        guard let imageURL = event.images.bestForHeroBanner?.url ?? event.images.first?.url else { return }

        Task {
            if let image = await ImageLoader.shared.loadImage(from: imageURL) {
                bannerImageView.image = image
                UIView.animate(withDuration: 0.25) {
                    self.bannerImageView.alpha = 1
                }
            }
        }
    }
}
