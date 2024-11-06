//
//  model.swift
//  testTextToPDF
//
//  Created by Akram Husseini on 06/11/2024.
//

import UIKit
import PDFKit
import SwiftUI

class PDFUtility {
    // Function to save car information to a PDF
    static func saveCarInfoToPDF(plateNumber: String, vinNumber: String, ownerName: String, taxNumber: String, commercialRecord: String, outputFileURL: URL) -> Bool {
        // Create a PDF document
        let pdfDocument = PDFDocument()
        
        // Create a single page with a specific size
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792) // A4 size in points
        let pdfPage = PDFPage()
        
        // Customize text positions and styles
        let title = "معلومات السيارة"
        let plateNumberTitle = "رقم اللوحة"
        let vinNumberTitle = "رقم الشاسيه (VIN)"
        let ownerNameTitle = "اسم المالك"
        let taxNumberTitle = "الرقم الضريبي"
        let commercialRecordTitle = "السجل التجاري"
        
        let fontSize: CGFloat = 14
        let titleFontSize: CGFloat = 16
        let padding: CGFloat = 20
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: titleFontSize),
            .foregroundColor: UIColor.black
        ]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.darkGray
        ]
        
        // Use UIGraphics to render content on the page
        UIGraphicsBeginPDFContextToFile(outputFileURL.path, pageBounds, nil)
        UIGraphicsBeginPDFPage()
        
        // Draw the title
        let titleRect = CGRect(x: padding, y: padding, width: pageBounds.width - 2 * padding, height: 30)
        title.draw(in: titleRect, withAttributes: titleAttributes)
        
        // Define positions for each piece of text
        let textStartY = titleRect.maxY + padding
        
        // Draw each label and text pair
        let labels = [plateNumberTitle, vinNumberTitle, ownerNameTitle, taxNumberTitle, commercialRecordTitle]
        let values = [plateNumber, vinNumber, ownerName, taxNumber, commercialRecord]
        
        for (index, label) in labels.enumerated() {
            let yOffset = textStartY + CGFloat(index) * 40 // Adjust spacing
            let labelRect = CGRect(x: padding, y: yOffset, width: 200, height: 20)
            let valueRect = CGRect(x: padding + 220, y: yOffset, width: pageBounds.width - padding * 2 - 220, height: 20)
            
            // Draw label and value
            label.draw(in: labelRect, withAttributes: textAttributes)
            values[index].draw(in: valueRect, withAttributes: textAttributes)
        }
        
        UIGraphicsEndPDFContext()
        
        return true
    }
}




