//
//  TrendingEventCell.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit

class TrendingEventCell: UICollectionViewCell {

    static let reuseIdentifier = "TrendingEventCell"

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.85).cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
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
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        contentView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(dateBadge)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            dateBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateBadge.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6),
            dateBadge.heightAnchor.constraint(equalToConstant: 20),
            dateBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.alpha = 0
    }

    func configure(with event: Event) {
        titleLabel.text = event.name
        dateBadge.text = "  \(formattedDate(event.dates.start.localDate))  "

        posterImageView.image = nil
        posterImageView.alpha = 0

        guard let imageURL = event.images.bestForHeroBanner?.url ?? event.images.first?.url else { return }

        Task {
            if let image = await ImageLoader.shared.loadImage(from: imageURL) {
                posterImageView.image = image
                UIView.animate(withDuration: 0.25) {
                    self.posterImageView.alpha = 1
                }
            }
        }
    }

    private func formattedDate(_ isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d"

        if let date = inputFormatter.date(from: isoDate) {
            return outputFormatter.string(from: date)
        }
        return isoDate 
    }
}
