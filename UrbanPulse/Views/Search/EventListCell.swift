//
//  EventListCell.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 25/09/26.
//

import UIKit

class EventListCell: UITableViewCell {

    static let reuseIdentifier = "EventListCell"

        private let posterImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.backgroundColor = .secondarySystemBackground
            iv.layer.cornerRadius = 8
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()

        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let dateLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            label.textColor = .secondaryLabel
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    private func setupViews() {
            contentView.addSubview(posterImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(dateLabel)


            NSLayoutConstraint.activate([
                posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                posterImageView.widthAnchor.constraint(equalToConstant: 70),
                posterImageView.heightAnchor.constraint(equalToConstant: 70),

                titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),

                dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
            ])
        }

    func configure(with event: Event) {
        titleLabel.text = event.name
        dateLabel.text = event.dates.start.localDate

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
}
