import UIKit

final class MyNFTViewModel {
    
    // MARK: - Properties
    var onChange: (() -> Void)?
    var onError: ((_ error: Error) -> Void)?
    
    private let networkClient = DefaultNetworkClient()
        
    private(set) var myNFTs: [NFTNetworkModel]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var likedIDs: [String]? {
        didSet {
            onChange?()
        }
    }
    
    private(set) var authors: [String: String] = [:]
    
    var sort: Sort? {
        didSet {
            guard let sort else { return }
            myNFTs = applySort(by: sort)
        }
    }
    
    // MARK: - Lifecycle
    init(nftIDs: [String], likedIDs: [String]){
        self.myNFTs = []
        self.likedIDs = likedIDs
        getMyNFTs(nftIDs: nftIDs)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(unlikeMyNFTfromFavorites),
            name: NSNotification.Name(rawValue: "favoriteUnliked"),
            object: nil
        )
    }
    
    // MARK: - Methods
    func getMyNFTs(nftIDs: [String]) {
        UIBlockingProgressHUD.show()
        var loadedNFTs: [NFTNetworkModel] = []
        
        nftIDs.forEach { id in
            networkClient.send(request: GetItemByIdRequest(id: id, item: .nft), type: NFTNetworkModel.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        loadedNFTs.append(nft)
                        if loadedNFTs.count == nftIDs.count {
                            self?.getAuthors(nfts: loadedNFTs)
                            self?.myNFTs? = loadedNFTs
                            UIBlockingProgressHUD.dismiss()
                        }
                    case .failure(let error):
                        self?.onError?(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    private func getAuthors(nfts: [NFTNetworkModel]){
        var authorsSet: Set<String> = []
        nfts.forEach { nft in
            authorsSet.insert(nft.author)
        }
        let semaphore = DispatchSemaphore(value: 0)
        authorsSet.forEach { author in
            networkClient.send(request: GetItemByIdRequest(id: author, item: .author), type: AuthorNetworkModel.self) { [weak self] result in
                switch result {
                case .success(let author):
                    self?.authors.updateValue(author.name, forKey: author.id)
                    if self?.authors.count == authorsSet.count { semaphore.signal() }
                case .failure(let error):
                    self?.onError?(error)
                    return
                }
            }
        }
        semaphore.wait()
    }
    
    @objc
    private func unlikeMyNFTfromFavorites(notification: Notification) {
        let nftID = notification.object as? String
        self.likedIDs = likedIDs?.filter({ $0 != nftID })
    }
    
    func toggleLikeFromMyNFT(id: String) {
        guard var likedIDs = self.likedIDs else { return }
        if likedIDs.contains(id) {
            self.likedIDs = likedIDs.filter({ $0 != id })
        } else {
            likedIDs.append(id)
            self.likedIDs = likedIDs
        }
    }
    
    private func applySort(by value: Sort) -> [NFTNetworkModel] {
        guard let myNFTs = myNFTs else { return [] }
        switch value {
        case .price:
            return myNFTs.sorted(by: { $0.price < $1.price })
        case .rating:
            return myNFTs.sorted(by: { $0.rating < $1.rating })
        case .name:
            return myNFTs.sorted(by: { $0.name < $1.name })
        }
    }
}

// MARK: - Nested types
extension MyNFTViewModel {
    
    enum Sort: Codable {
        case price
        case rating
        case name
    }
}
