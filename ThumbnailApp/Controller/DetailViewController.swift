
import UIKit
import WebKit

// MARK: Logic Method
internal extension DetailViewController {
    
    ///Method to find the correct youtube video
    func findVideo(caption: String) -> String {
        var urlAddress:String = ""
        switch (caption) {
            case "Lonely Railroad":
                urlAddress = "https://youtu.be/-xNus37RhWA"
                break
            case "Autumn Path":
                urlAddress = "https://youtu.be/Go4YMAws6BU"
                break
            case "Cloudy Hill":
                urlAddress = "https://youtu.be/ivjZWCU9pKA"
                break
            case "Wind Surf":
                urlAddress = "https://youtu.be/8bYtDBZkrpM"
                break
            case "Sidewalk Cafe":
                urlAddress = "https://youtu.be/wG_FcMwoU6M"
                break
            case "Green Forest":
                urlAddress = "https://youtu.be/BjaTMx8ZWK8"
                break
            case "Sunset Ray":
                urlAddress = "https://youtu.be/SJJFKN3HjwU"
                break
            case "Elephant Family":
                urlAddress = "https://youtu.be/gsqlpcVEsqc"
                break
            case "Snowy Mountain":
                urlAddress = "https://youtu.be/ftgX04OOmNw"
                break
            case "Red House":
                urlAddress = "https://youtu.be/ZZJ6tGRiI9k"
                break
            default:
                break
        }
        
        return urlAddress
    }
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblCaption: UILabel!
    public var _caption:String = ""
    
    private var detailController:DetailsCollectionViewController?
    
    // MARK : Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblCaption.text = _caption
        lblCaption.textColor = UIColor.systemOrange
        
        let urlAddress = self.findVideo(caption: _caption)
        detailController?.playVideo(urlAddress: urlAddress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Lock the orientation for this view controller
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.allowRotate = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailViewSegue") {
            let embedVC = segue.destination as! DetailsCollectionViewController
            detailController = embedVC
        }
    }
    

}
