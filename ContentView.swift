import SwiftUI
import PhotosUI

struct ContentView: View {
    // Stav pro vybraný obrázek z galerie
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil

    var body: some View {
        ZStack {
            // 1. Pozadí: Náhodný obrázek z galerie nebo výchozí pozadí
            if let selectedImage = selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("Vyber fotku z galerie! 📸")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }

            // 2. Hlavní vrstva s ovládáním a skleněným kruhem
            VStack {
                Spacer()

                // Kruh (200x200) s iOS "liquid glass" efektem 💧✨
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial) // iOS Liquid Glass / Material efekt
                        .frame(width: 200, height: 200)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)

                    Text("Liquid Glass 🫧")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Spacer()

                // Tlačítko pro výběr fotky z galerie
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    HStack {
                        Image(systemName: "photo.badge.plus")
                        Text("Otevřít galerii 🖼️")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
