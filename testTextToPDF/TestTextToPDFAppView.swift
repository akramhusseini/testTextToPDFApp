//
//  TestTextToPDFAppView.swift
//  testTextToPDF
//
//  Created by Akram Husseini on 06/11/2024.
//

import SwiftUI
import PDFKit
import UIKit

struct TestTextToPDFAppView: View {
    // Sample data to match the design
    let plateNumber = "أ ب ج 1234"
    let vinNumber = "12345678123450417"
    let ownerName = "محمد صالح عبد العزيز سليم"
    let taxNumber = "123456789012345"
    let commercialRecord = "1010123456"
    
    @State private var isCopiedToClipboard = false // Control to show success alert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("معلومات السيارة")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 16)
            
            // Info rows with correct labels and values
            infoRow(label: "رقم اللوحة", value: plateNumber)
            infoRow(label: "رقم الشاسيه (VIN)", value: vinNumber)
            infoRow(label: "اسم المالك", value: ownerName)
            infoRow(label: "الرقم الضريبي", value: taxNumber)
            infoRow(label: "السجل التجاري", value: commercialRecord)
            
            Spacer()
            
            // Button to generate PDF and copy it to the clipboard
            Button(action: {
                savePDFToClipboard()
            }) {
                Text("Save PDF to Clipboard")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .alert(isPresented: $isCopiedToClipboard) {
                Alert(title: Text("Success"), message: Text("PDF copied to clipboard"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .padding()
    }
    
    // Helper view for each row
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(value)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(label)
                .font(.body)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    // Function to save PDF to clipboard
    private func savePDFToClipboard() {
        // Save to the Documents directory instead of the temporary directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentsDirectory.appendingPathComponent("CarInfo.pdf")
        
        // Call the utility function to create the PDF
        let success = PDFUtility.saveCarInfoToPDF(
            plateNumber: plateNumber,
            vinNumber: vinNumber,
            ownerName: ownerName,
            taxNumber: taxNumber,
            commercialRecord: commercialRecord,
            outputFileURL: outputFileURL
        )
        
        // Check if the file was created successfully and exists at the path
        if success, FileManager.default.fileExists(atPath: outputFileURL.path) {
            print("PDF created successfully at: \(outputFileURL.path)")
            
            // Load the PDF file as Data
            if let pdfData = try? Data(contentsOf: outputFileURL) {
                // Copy the PDF data to the clipboard
                UIPasteboard.general.setData(pdfData, forPasteboardType: "com.adobe.pdf")
                isCopiedToClipboard = true
            } else {
                print("Failed to load PDF data")
            }
        } else {
            print("Failed to create PDF or file does not exist")
        }
    }
}

