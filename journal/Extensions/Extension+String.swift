//
//  Extension+String.swift
//  journal
//
//  Created by Atirek Pothiwala on 26/07/25.
//

import UIKit

extension String {
    func loadImageFromDocuments() -> UIImage? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first?.appendingPathComponent(self) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    func deleteImageFromDocuments() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first?.appendingPathComponent(self) else {
            return
        }
        do {
            if FileManager.default.fileExists(atPath: url.path()) {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    func decodeArray() -> [String] {
        if let jsonData = self.data(using: .utf8) {
            do {
                return try JSONDecoder().decode([String].self, from: jsonData)
            } catch {
                print("Decoding error: \(error)")
            }
        }
        return []
    }
}

extension [String] {
    func encodeArray() -> String {
        var jsonString: String?
        do {
            let jsonData = try JSONEncoder().encode(self)
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch (let e as NSError) {
            print("Error encoding JSON: \(e)")
        }
        return jsonString ?? ""
    }
}
