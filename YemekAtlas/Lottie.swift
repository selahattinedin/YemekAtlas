import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(animationName)
        animationView.contentMode = .scaleAspectFit // Taşmaları önler
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 2.0), // %80 oranında küçült
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.5) // Yüksekliği %50 yap
        ])
        
        animationView.play()
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
