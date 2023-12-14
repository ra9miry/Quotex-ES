//
//  CoinsAPI.swift
//  Quotex ES
//
//  Created by Радмир Тельман on 14.12.2023.
//

import Foundation

struct CryptoAPI {

    static func fetchPrice(for crypto: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(crypto)&vs_currencies=usd"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let cryptoData = jsonResponse[crypto] as? [String: Double],
                   let price = cryptoData["usd"] {
                    completion(String(price))
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
