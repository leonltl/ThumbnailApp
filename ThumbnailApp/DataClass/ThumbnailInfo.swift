
/// Class that store the properties inside a base class so that any new properties can be added or initiailize
public class BaseThumbnailInfoData {
    enum CodingKeys: String, CodingKey {
        case imageUrl
        case caption
    }
    
    public var imageUrl: String = ""
    public var caption: String = ""
    public var likesCount: Int = 0
    public var comments: [String] = [String]()
}

/// Class that inherit the decodable class for decoding purposes
public class ThumbnailInfo : BaseThumbnailInfoData, Decodable {
    required public init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: ThumbnailInfo.CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        caption = try container.decode(String.self, forKey: .caption)
    }
}
