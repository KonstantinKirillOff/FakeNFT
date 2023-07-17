import UIKit

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProfileViewModelProtocol
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = EditProfileView(frame: .zero, viewController: self, viewModel: viewModel)
    }
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
