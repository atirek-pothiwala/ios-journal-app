//
//  Extension+UIImage.swift
//  journal
//
//  Created by Atirek Pothiwala on 25/07/25.
//

import UIKit

extension UIImage {
    func saveToDocuments(quality: Double = 0.5) -> String? {
        guard let data = self.jpegData(compressionQuality: quality) else {
            return nil
        }
        let fileName = UUID().uuidString + ".jpg"
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first?.appendingPathComponent(fileName) else {
            return nil
        }

        do {
            try data.write(to: url)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }

}
