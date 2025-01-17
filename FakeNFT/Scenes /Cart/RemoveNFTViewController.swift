import UIKit

protocol RemoveNFTViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(_ model: NFTModel)
}

final class RemoveNFTViewController: UIViewController {
    // MARK: - Layout elements

    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        return label
    }()
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var cancelButton: Button = {
        let button = Button(title: "Вернуться")
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    private lazy var confirmButton: Button = {
        let button = Button(title: "Удалить")
            .titleColor(.red)
            .font(.bodyRegular)
            .cornerRadius(12)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    weak var delegate: RemoveNFTViewControllerDelegate?
    private var model: NFTModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Actions

    @objc
    private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc
    private func didTapConfirmButton() {
        guard let model else { return }
        delegate?.didTapConfirmButton(model)
    }

    // MARK: - Public

    func configure(with model: NFTModel) {
        self.model = model
        if
            let image = model.images.first,
            let url = URL(string: image)
        {
            nftImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Layout methods

private extension RemoveNFTViewController {
    func setupView() {
        [nftImageView, alertLabel, buttonsStackView ]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(blurView)
        view.addSubview(nftImageView)
        view.addSubview(alertLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(confirmButton)
        buttonsStackView.addArrangedSubview(cancelButton)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // nftImageView
            nftImageView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: alertLabel.topAnchor, constant: -12),
            nftImageView.widthAnchor.constraint(equalToConstant: CartNFTCell.Constants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: CartNFTCell.Constants.imageSize),
            // alertLabel
            alertLabel.widthAnchor.constraint(equalToConstant: 180),
            alertLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // buttonsStackView
            buttonsStackView.centerXAnchor.constraint(equalTo: alertLabel.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 20),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 262),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
