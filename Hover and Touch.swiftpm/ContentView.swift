import SwiftUI

struct ContentView: View {
    var body: some View {
        HoverTouchParticleView()
            .ignoresSafeArea(.all, edges: .all)
    }
}

struct HoverTouchParticleView: UIViewRepresentable {
    func makeUIView(context: Context) -> some HoverTouchParticleUIView {
        return HoverTouchParticleUIView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
