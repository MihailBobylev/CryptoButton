import UIKit

class ViewController: UIViewController {
    private lazy var translucentView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "ldkfnghjkndfktjnhdfkghnl;dfkgnhjfngknhjnf"
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainButtonView: MainButtonView = {
        let view = MainButtonView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector (tapAction))
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(longPressureAction(_:)))
        longGesture2.minimumPressDuration = 0.1
        translucentView.addGestureRecognizer(tapGesture2)
        translucentView.addGestureRecognizer(longGesture2)
        
        setupUI()
    }
    
    @objc func tapAction() {
        mainButtonView.tapAction()
    }

    @objc func longPressureAction(_ gestureRecognizer: UILongPressGestureRecognizer) {
        mainButtonView.longPressureAction(gestureRecognizer)
    }
    
    private func setupUI() {
        view.addSubview(mainLabel)
        view.addSubview(translucentView)
        view.addSubview(mainButtonView)
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: 100),
            
            translucentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            translucentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            translucentView.topAnchor.constraint(equalTo: view.topAnchor),
            translucentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            mainButtonView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            mainButtonView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension ViewController: MainButtonViewDelegate {
    func hideBlur(_ hide: Bool) {
        translucentView.alpha = hide ? 0 : 1
    }
    
    func getView() -> UIView {
        return view
    }
}
