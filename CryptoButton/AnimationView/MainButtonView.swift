import UIKit

protocol MainButtonViewDelegate: AnyObject {
    func hideBlur(_ hide: Bool)
    func getView() -> UIView
    func uploadMainButtonViewConstraints(isOpened: Bool)
}

final class MainButtonView: UIView {
    enum Constants: CGFloat {
        case offsetX1 = 150
        case offsetY1 = 45
        case offsetX2 = 78
        case offsetY2 = 85
        case offsetY3 = 100
    }
    
    private lazy var blanckView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var grandTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gamecontroller.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var slideButtonFirst: SlideButton = {
        let button = SlideButton(title: "Stake", image: UIImage(systemName: "person.circle"), id: 1)
        button.delegate = self
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var slideButtonSecond: SlideButton = {
        let button = SlideButton(title: "Send", image: UIImage(systemName: "house"), id: 2)
        button.delegate = self
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var slideButtonThird: SlideButton = {
        let button = SlideButton(title: "Receive", image: UIImage(systemName: "timer"), id: 3)
        button.delegate = self
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var slideButtonFourth: SlideButton = {
        let button = SlideButton(title: "Supply", image: UIImage(systemName: "globe.central.south.asia.fill"), id: 4)
        button.delegate = self
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var slideButtonFifth: SlideButton = {
        let button = SlideButton(title: "Borrow", image: UIImage(systemName: "heart.fill"), id: 5)
        button.delegate = self
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: MainButtonViewDelegate?
    
    private lazy var centerYconst1 = slideButtonFirst.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
    private lazy var centerYconst2 = slideButtonSecond.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
    private lazy var centerYconst3 = slideButtonThird.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
    private lazy var centerYconst4 = slideButtonFourth.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
    private lazy var centerYconst5 = slideButtonFifth.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor)
    
    private lazy var centerXconst1 = slideButtonFirst.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
    private lazy var centerXconst2 = slideButtonSecond.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
    private lazy var centerXconst4 = slideButtonFourth.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
    private lazy var centerXconst5 = slideButtonFifth.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
    
    var isOpened = true
    
    init() {
        super.init(frame: .zero)
        setupGestures()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainButton.layer.cornerRadius = mainButton.bounds.width / 2
        
        mainButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainButton.layer.shadowRadius = 10
        mainButton.layer.shadowOpacity = 1
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (backgoundTapAction))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressureAction(_:)))
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(backgroundLongPressureAction(_:)))
        longGesture.minimumPressDuration = 0.3
        longGesture2.minimumPressDuration = 0.1
        mainButton.addGestureRecognizer(longGesture)
        blanckView.addGestureRecognizer(tapGesture)
        blanckView.addGestureRecognizer(longGesture2)
    }
    
    @objc func tapAction() {
        if isOpened {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1)
            animateOut()
        } else {
            animateIn()
        }
    }
    
    @objc func backgoundTapAction() {
        if !isOpened {
            animateIn()
        }
    }

    @objc func backgroundLongPressureAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if !isOpened {
            longPressureAction(gestureRecognizer)
        }
    }
    
    @objc func longPressureAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            if isOpened {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 1)
                animateOut()
                UIView.animate(withDuration: 0.1, delay: 0.1) {
                    self.mainButton.alpha = 0
                }
            } else {
                mainButton.alpha = 0
            }
            checkIntersection(gestureRecognizer)
            grandTitleLabel.alpha = 1
            NotificationCenter.default.post(name: .hideTitle, object: self,
                                            userInfo: ["isHidden": true])
        case .changed:
            checkIntersection(gestureRecognizer)
        case .ended:
            NotificationCenter.default.post(name: .makeDefaultSize, object: self)
            NotificationCenter.default.post(name: .hideTitle, object: self,
                                            userInfo: ["isHidden": false])
            grandTitleLabel.alpha = 0
            grandTitleLabel.text = ""
            animateIn()
            UIView.animate(withDuration: 0.1) {
                self.mainButton.alpha = 1
            }
        default:
            break
        }
    }
    
    private func checkIntersection(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        let correctLocation = CGPoint(x: location.x - 30, y: location.y - 20)
        let tapRect = CGRect(origin: correctLocation, size: CGSize(width: 20, height: 20))
        
        var itemID = 0
        var grandText = ""
        var intersection = CGRectIntersection(slideButtonFirst.frame, tapRect)
        if !CGRectIsNull(intersection) {
            itemID = 1
            grandText = slideButtonFirst.title
        }
        
        intersection = CGRectIntersection(slideButtonSecond.frame, tapRect)
        if !CGRectIsNull(intersection) {
            itemID = 2
            grandText = slideButtonSecond.title
        }
        
        intersection = CGRectIntersection(slideButtonThird.frame, tapRect)
        if !CGRectIsNull(intersection) {
            itemID = 3
            grandText = slideButtonThird.title
        }
        
        intersection = CGRectIntersection(slideButtonFourth.frame, tapRect)
        if !CGRectIsNull(intersection) {
            itemID = 4
            grandText = slideButtonFourth.title
        }
        
        intersection = CGRectIntersection(slideButtonFifth.frame, tapRect)
        if !CGRectIsNull(intersection) {
            itemID = 5
            grandText = slideButtonFifth.title
        }
        
        if itemID == 0 {
            grandText = ""
        }
        
        grandTitleLabel.text = grandText
        NotificationCenter.default.post(name: .intersection, object: self,
                                        userInfo: ["itemID": itemID])
    }
    
    private func animateOut() {
        isOpened = false
        delegate?.hideBlur(false)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.mainButton.setImage(UIImage(systemName: "square.and.arrow.up.on.square.fill"), for: .normal)
            
            self.centerYconst1.constant -= Constants.offsetY1.rawValue
            self.centerXconst1.constant -= Constants.offsetX1.rawValue
            self.slideButtonFirst.alpha = 1
            
            self.centerYconst2.constant -= Constants.offsetY2.rawValue
            self.centerXconst2.constant -= Constants.offsetX2.rawValue
            self.slideButtonSecond.alpha = 1
            
            self.centerYconst3.constant -= Constants.offsetY3.rawValue
            self.slideButtonThird.alpha = 1
            
            self.centerYconst4.constant -= Constants.offsetY2.rawValue
            self.centerXconst4.constant += Constants.offsetX2.rawValue
            self.slideButtonFourth.alpha = 1
            
            self.centerYconst5.constant -= Constants.offsetY1.rawValue
            self.centerXconst5.constant += Constants.offsetX1.rawValue
            self.slideButtonFifth.alpha = 1
            
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.uploadMainButtonViewConstraints(isOpened: self.isOpened)
        }
    }
    
    private func animateIn() {
        isOpened = true
        delegate?.hideBlur(true)
        UIView.animate(withDuration: 0.1) {
            self.mainButton.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
            
            self.centerYconst1.constant += Constants.offsetY1.rawValue
            self.centerXconst1.constant += Constants.offsetX1.rawValue
            self.slideButtonFirst.alpha = 0
            
            self.centerYconst2.constant += Constants.offsetY2.rawValue
            self.centerXconst2.constant += Constants.offsetX2.rawValue
            self.slideButtonSecond.alpha = 0
            
            self.centerYconst3.constant += Constants.offsetY3.rawValue
            self.slideButtonThird.alpha = 0
            
            self.centerYconst4.constant += Constants.offsetY2.rawValue
            self.centerXconst4.constant -= Constants.offsetX2.rawValue
            self.slideButtonFourth.alpha = 0
            
            self.centerYconst5.constant += Constants.offsetY1.rawValue
            self.centerXconst5.constant -= Constants.offsetX1.rawValue
            self.slideButtonFifth.alpha = 0
            
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.uploadMainButtonViewConstraints(isOpened: self.isOpened)
        }
    }
    
    private func setupUI() {
        addSubview(blanckView)
        addSubview(grandTitleLabel)
        addSubview(slideButtonFirst)
        addSubview(slideButtonSecond)
        addSubview(slideButtonThird)
        addSubview(slideButtonFourth)
        addSubview(slideButtonFifth)
        addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            blanckView.topAnchor.constraint(equalTo: topAnchor),
            blanckView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blanckView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blanckView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainButton.widthAnchor.constraint(equalToConstant: 80),
            mainButton.heightAnchor.constraint(equalToConstant: 80),
            
            centerYconst1,
            centerYconst2,
            centerYconst3,
            centerYconst4,
            centerYconst5,
            
            centerXconst1,
            centerXconst2,
            slideButtonThird.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerXconst4,
            centerXconst5,
            
            grandTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            grandTitleLabel.bottomAnchor.constraint(equalTo: slideButtonThird.topAnchor, constant: -10)
        ])
    }
}

extension MainButtonView: SlideButtonViewDelegate {
    func longPressureItemAction(_ gestureRecognizer: UILongPressGestureRecognizer, itemTitle: String) {
        grandTitleLabel.text = itemTitle
        longPressureAction(gestureRecognizer)
    }
    
    func tapItemAction(id: Int) {
        animateIn()
    }
}
