
import UIKit

// MARK: - Logic Methods
internal extension MainViewController {
    
    /// Method to load the pictures
    /// - Parameters:
    ///   - url: the url address of the rest api
    func loadPictures(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                self.displayNoThumbnail()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.displayNoThumbnail()
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let thumbnailInfo = try decoder.decode([ThumbnailInfo].self, from: data)
                    
                    if (thumbnailInfo.count == 0) {
                        self.displayNoThumbnail()
                        return
                    }
                    
                    self.displayThumbnails(thumbnails: thumbnailInfo)
                }
                catch _ {
                    self.displayNoThumbnail()
                }
            }
            
        }.resume()
    }
    
    /// Method to display error when there are no thumbnail
    private func displayNoThumbnail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.btnLoadPictures.animate(animation: .expand)
            self.imagesController?.loadNoThumbnail()
        }
    }
    
    /// Method to display all the thumbnails
    private func displayThumbnails(thumbnails: [ThumbnailInfo]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.btnLoadPictures.animate(animation: .expand)
            self.imagesController?.loadThumbnailList(thumbnailData: thumbnails)
        }

    }
    
}

// MARK: Event Actions
internal extension MainViewController {
    @objc func onListenToLoadPictures(_ sender: Any) {
        self.btnLoadPictures.storedTitle = "Load Pictures"
        btnLoadPictures.animate(animation: .collapse)
        imagesController?.clearThumbnailList()
        
        guard let url = URL(string: apiUrl) else {
            self.displayNoThumbnail()
            return
        }
        
        self.loadPictures(url: url)
    }
}

class MainViewController: UIViewController {
    
    /// ux variables
    @IBOutlet weak var viewBtnLoadPicturesWrapper: UIView!
    @IBOutlet weak var btnLoadPictures: SpinnerButton!
    @IBOutlet weak var containerImages: UIView!
    
    /// non ux variables
    private var imagesController:ImagesCollectionViewController?
    private var apiUrl:String = "https://mnktechnology.com/tech/mytester/web/web-service/dev-get-image-list"
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        barButtonItem.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = barButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(onListenToLoadPictures), name: Notification.Name("TriggerLoadPictures"), object: nil)
        
        self.navigationController?.accessibilityLabel = "MainViewController"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.allowRotate = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewBtnLoadPicturesWrapper.backgroundColor = UIColor.white.withAlphaComponent(0)
        self.btnLoadPictures.backgroundColor = UIColor.systemBlue
        //self.btnLoadPictures.spinnerColor = UIColor.white.cgColor
        self.btnLoadPictures.frame = CGRect(x: 0, y: 0, width: self.viewBtnLoadPicturesWrapper.bounds.width, height: self.viewBtnLoadPicturesWrapper.bounds.height)
    }
    
    // Mark: - Button Event
    @IBAction func onBtnLoadPictures(_ sender: UIButton) {
        self.btnLoadPictures.storedTitle = "Load Pictures"
        btnLoadPictures.animate(animation: .collapse)
        imagesController?.clearThumbnailList()
        
        guard let url = URL(string: apiUrl) else {
            self.displayNoThumbnail()
            return
        }
        
        self.loadPictures(url: url)
    }
    
    // MARK: - Segue navigation function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "imageContainerSegue") {
            let embedVC = segue.destination as! ImagesCollectionViewController
            imagesController = embedVC
        }
    }
    
}

