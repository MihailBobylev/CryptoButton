//
//  SlideButton.swift
//  CryptoButton
//
//  Created by Михаил Бобылев on 18.05.2023.
//

import UIKit

protocol SlideButtonViewDelegate: AnyObject {
    func tapItemAction(id: Int)
    func longPressureItemAction(_ gestureRecognizer: UILongPressGestureRecognizer, itemTitle: String)
}

final class SlideButton: UIView {
    enum Constants: CGFloat {
        case itemSize = 50
        case scale = 1.4
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var slideButton: UIButton = {
        let button = UIButton()
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: SlideButtonViewDelegate?
    
    var title: String
    private var image: UIImage?
    private var isAnimating = false
    private let id: Int
    
    
    private lazy var heightConstraint = slideButton.heightAnchor.constraint(equalToConstant: Constants.itemSize.rawValue)
    private lazy var widthConstraint = slideButton.widthAnchor.constraint(equalToConstant: Constants.itemSize.rawValue)
    
    init(title: String, image: UIImage?, id: Int) {
        self.title = title
        self.image = image
        self.id = id
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkIntersection(_:)),
                                               name: .intersection,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeDefaultSize(_:)),
                                               name: .makeDefaultSize,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideTitle(_:)),
                                               name: .hideTitle,
                                               object: nil)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressureAction(_:)))
        longGesture.minimumPressDuration = 0.1
        addGestureRecognizer(longGesture)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        slideButton.layer.cornerRadius = slideButton.bounds.width / 2
        
        slideButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        slideButton.layer.shadowRadius = 10
        slideButton.layer.shadowOpacity = 1
    }
    
    @objc private func checkIntersection(_ notification: Notification) {
        if let itemId = notification.userInfo?["itemID"] as? Int {
            titleLabel.alpha = 0
            if id == itemId {
                if !isAnimating {
                    isAnimating = true
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1)
                    UIView.animate(withDuration: 0.2) {
                        let scaleTransform = CGAffineTransform(scaleX: Constants.scale.rawValue, y: Constants.scale.rawValue)
                        let transitionTransform = CGAffineTransform(translationX: 0, y: -10)
                        self.slideButton.transform = scaleTransform.concatenating(transitionTransform)
                    }
                }
            } else if isAnimating {
                isAnimating = false
                UIView.animate(withDuration: 0.2) {
                    let scaleTransform = CGAffineTransform(scaleX: 1, y: 1)
                    let transitionTransform = CGAffineTransform(translationX: 0, y: 0)
                    self.slideButton.transform = scaleTransform.concatenating(transitionTransform)
                }
            }
        }
    }
    
    @objc func longPressureAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        delegate?.longPressureItemAction(gestureRecognizer, itemTitle: title)
    }
    
    @objc private func makeDefaultSize(_ notification: Notification) {
        let scaleTransform = CGAffineTransform(scaleX: 1, y: 1)
        let transitionTransform = CGAffineTransform(translationX: 0, y: 0)
        slideButton.transform = scaleTransform.concatenating(transitionTransform)
        titleLabel.alpha = 1
    }
    
    @objc private func hideTitle(_ notification: Notification) {
        if let isHidden = notification.userInfo?["isHidden"] as? Bool {
            titleLabel.isHidden = isHidden
        }
    }
    
    @objc func buttonTap(_ button: UIButton) {
        delegate?.tapItemAction(id: id)
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(slideButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            slideButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            slideButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            slideButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            slideButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightConstraint,
            widthConstraint
        ])
    }
}
