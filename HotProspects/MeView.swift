//
//  MeView.swift
//  HotProspects
//
//  Created by Игорь Верхов on 26.10.2023.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @AppStorage("name") private var name = "Anonymus"
    @AppStorage("email") private var email = "you@yoursite.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .font(.title)
                    .textContentType(.name)
                TextField("Email", text: $email)
                    .font(.title)
                    .textContentType(.emailAddress)
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: qrCode).interpolation(.none), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                    }
            }
            .navigationTitle("Your code")
            .onAppear(perform: updateCode)
            .onChange(of: name, updateCode)
            .onChange(of: email, updateCode)
        }
    }
    
    func generateQrCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return  UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQrCode(from: "\(name)\n\(email)")
    }
}

#Preview {
    MeView()
}
