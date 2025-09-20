import Foundation

/// Header kalitlari
struct Header {
    enum Key: Hashable {
        /// Standart kalitlar
        case contentType
        case accept
        case authorization
        case accessToken
        case language
        case macAddress
        case custom(key: String) // Foydalanuvchi tomonidan belgilangan kalit
        
        /// Kalitning string qiymati
        var key: String {
            switch self {
            case .contentType: return "Content-Type"
            case .accept: return "Accept"
            case .authorization: return "Authorization"
            case .accessToken: return "access_token"
            case .language: return "Accept-Language"
            case .macAddress: return "mac_address"
            case .custom(let key): return key
            }
        }
        
        // Hashable implementatsiyasi
        func hash(into hasher: inout Hasher) {
            hasher.combine(key)
        }
    }
    
    /// Header qiymatlari
    enum Value {
        case applicationJSON
        case applicationFormURLEncoded
        case multipartFormData(boundary: String = "Boundary-\(UUID().uuidString)")
        case language
        case custom(value: String)
        case token
        
        /// Qiymatning string shakli
        var value: String {
            switch self {
            case .applicationJSON:
                return "application/json"
            case .applicationFormURLEncoded:
                return "application/x-www-form-urlencoded"
            case .multipartFormData(let boundary):
                return "multipart/form-data; boundary=\(boundary)"
            case .language:
                return "" // Kesh orqali tilni olish
            case .custom(let value):
                return value
            case .token:
                return "" // Tokenni olish
            }
        }
    }
}
