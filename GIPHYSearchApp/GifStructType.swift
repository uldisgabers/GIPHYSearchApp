//
//  GifStructType.swift
//  GIPHYSearchApp
//
//  Created by Uldis on 02/04/2024.
//


struct Gif: Identifiable, Decodable {
    let id: String
    var title: String
    let slug: String
    var images: Images
    
    struct Images: Decodable {
        var fixed_width: FixedWidth
        
        struct FixedWidth: Decodable {
            var url: String
            var width: String
            let height: String
        }
        
        enum CodingKeys: String, CodingKey {
            case fixed_width
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, images
    }
}


struct GiphyResponse: Decodable {
    let data: [Gif]
}
