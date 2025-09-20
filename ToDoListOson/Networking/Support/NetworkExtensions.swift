

import Foundation

extension URLRequest {
    /**
     Sets value to header field
     
     - Parameter key: Header key
     - Parameter value: Header value
     */
    mutating func add(key: Header.Key, value: Header.Value) {
        setValue(value.value, forHTTPHeaderField: key.key)
    }
    
    mutating func add(contentOf headers: [Header.Key: Header.Value]) {
        headers.forEach { add(key: $0.key, value: $0.value) }
    }
}
