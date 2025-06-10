import Foundation

class LeonardoAIClient {
    private let apiKey: String
    private let baseURL = "https://cloud.leonardo.ai/api/rest/v1"
    
    init() {
        // Property List'ten API anahtarını oku
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "Image_Api_Key") as? String {
            self.apiKey = apiKey
        } else {
            self.apiKey = ""
            print("HATA: Image_Api_Key bulunamadı! Info.plist dosyasını kontrol edin.")
        }
    }
    
    // API anahtarınızı doğrulamak için kullanıcı bilgilerini getirin
    func getCurrentUser() async throws -> [String: Any] {
        let endpoint = "/users/me"
        return try await makeRequest(to: endpoint, method: "GET")
    }
    
    // Görsel oluşturmak için istek gönderen fonksiyon
    func generateImage(prompt: String, modelId: String = "1e60896f-3c26-4296-8ecc-53cc3cdc0903") async throws -> [String: Any] {
        let endpoint = "/generations"
        
        let requestBody: [String: Any] = [
            "prompt": prompt,
            "modelId": modelId,
            "width": 512,
            "height": 512,
            "num_images": 1,
            "promptMagic": true
        ]
        
        return try await makeRequest(to: endpoint, method: "POST", body: requestBody)
    }
    
    // Oluşturma durumunu kontrol eden fonksiyon
    func getGenerationById(generationId: String) async throws -> [String: Any] {
        let endpoint = "/generations/\(generationId)"
        return try await makeRequest(to: endpoint, method: "GET")
    }
    
    // API isteklerini yapan yardımcı fonksiyon
    private func makeRequest(to endpoint: String, method: String, body: [String: Any]? = nil) async throws -> [String: Any] {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NSError(domain: "InvalidURL", code: 0)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let responseString = String(data: data, encoding: .utf8) ?? "Bilinmeyen hata"
            throw NSError(domain: "APIError", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: ["response": responseString])
        }
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            return json
        } else {
            throw NSError(domain: "JSONParsingError", code: 0)
        }
    }
}
