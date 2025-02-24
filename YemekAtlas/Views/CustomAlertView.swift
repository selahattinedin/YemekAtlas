import SwiftUI

struct CustomAlertView: View {
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    let confirmButtonTitle: LocalizedStringKey
    let cancelButtonTitle: LocalizedStringKey
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(message)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    Divider()
                    
                    // Buttons side by side
                    HStack(spacing: 0) {
                        Button(cancelButtonTitle) {
                            cancelAction()
                            isPresented = false
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.blue)
                        .font(.system(size: 17, weight: .regular))
                        
                        Divider()
                        
                        Button(confirmButtonTitle) {
                            confirmAction()
                            isPresented = false
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.red)
                        .font(.system(size: 17, weight: .semibold))
                    }
                    .frame(height: 44)
                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(UIColor.systemBackground))
                )
                .padding(.horizontal, 40)
                .frame(maxWidth: 270)
                .fixedSize(horizontal: false, vertical: true) // Bu satır alert'in içeriğe göre boyutlanmasını sağlar
            }
        }
    }
}

#Preview {
    @State var isPresented = true
    return CustomAlertView(
        title: "Çıkış Yap",  // Yerelleştirilmiş metin
        message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",  // Yerelleştirilmiş metin
        confirmButtonTitle: "Çıkış Yap",  // Yerelleştirilmiş metin
        cancelButtonTitle: "İptal",  // Yerelleştirilmiş metin
        confirmAction: {
            print("Çıkış yapıldı.")
        },
        cancelAction: {
            print("İptal edildi.")
        },
        isPresented: $isPresented
    )
}
