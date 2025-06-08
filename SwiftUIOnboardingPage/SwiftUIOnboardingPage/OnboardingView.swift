import SwiftUI


enum OnboardingPage: Int , CaseIterable {
    case browseMenu
    case quickDelivery
    case orderTracking
    
    var title: String {
        switch self {
        case .browseMenu: return "Menüye Göz At"
        case .quickDelivery: return "Şimşek Hızında Teslimat"
        case .orderTracking: return "Gerçek Zamanlı Sipariş Takibi"
        }
    }
    var description: String {
        switch self {
        case .browseMenu: return "En yüksek puanlı şeflerden gelen süslemelerle dolu bir dünyayı keşfedin."
        case .quickDelivery: return "Dünyanın her yerinden kapınıza teslim"
        case .orderTracking: return "Siparişinizi gerçek zamanlı olarak takip edin"
        }
    }
}

struct OnboardingView: View {
    @State var currentPage: Int = 0
    @State var isAnimating: Bool = false
    @State var deliveryOffset : Bool = false
    @State var trackingProgress : CGFloat = 0.0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach (OnboardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring() , value: currentPage)
            
            HStack(spacing: 12){
                ForEach (0..<OnboardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ?  Color.blue : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 :8 )
                        .animation(.spring(), value: currentPage)
                    
                }
            }
        }
        .padding(.bottom , 20)
        //Button
        Button {
            withAnimation(.spring()){
                if currentPage  < OnboardingPage.allCases.count - 1 {
                    currentPage += 1
                    isAnimating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ,
                                                  execute: {
                        isAnimating = true
                        
                    })
                } else {
                    
                }
            }
        }label: {
            Text(currentPage < OnboardingPage.allCases.count - 1 ? "İleri" : "Başlamaya Hazır mısınız?")
                .font(.system(.title3 , design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical , 16)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.red.opacity(0.3) , radius: 10 , x: 0, y: 5)
                
        }
        .padding(.horizontal, 30)
        .padding(.bottom , 30)
        
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation {
                    isAnimating = true
                }
            })
            
        }
   
    }
    
    private var foodImagesGroup: some View {
        ZStack {
            Image("hamburgerw")
                .resizable()
                .scaledToFit()
                .frame(height: 240)
                .offset(y: isAnimating ? 0 : 20)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
                .zIndex(1)
         
        }
        
    }
    
    private var orderTrackingAnimation: some View {
        ZStack  {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .frame(width: 250 , height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
            
            Image("order")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .opacity(isAnimating ? 1 :0)
            .scaleEffect(isAnimating ? 1 : 0.8)
            .rotation3DEffect(.degrees(isAnimating ? 360 : 1), axis: (x: 0, y: 1, z: 0))
            .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating )
            
            
            ForEach(0..<4) { index in
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.blue)
                    .offset(
                        x : 100 * cos(Double(index) * .pi / 2),
                        y : 100 * sin(Double(index) * .pi / 2)
                    )
                    .opacity(isAnimating ? 1 :0)
                    .scaleEffect(isAnimating ? 1 : 0)
                    .animation(.spring(dampingFraction: 0.6).delay(0.1), value: isAnimating )
            }
        }
    }
    
    
    
    
    private var deliverAnimation: some View {
        ZStack  {
            Circle()
                .stroke(Color.blue.opacity(0.2) , lineWidth: 2)
                .frame(width: 250 , height: 250)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
            Image("deliveryyy")
                .resizable()
            .scaledToFit()
            .frame(height: 200)
            .offset(y: deliveryOffset ? 20 : 0 )
            .rotationEffect(.degrees(deliveryOffset ? 5 : -5))
            .opacity(isAnimating ? 1 :0)
            .animation(.spring(dampingFraction: 0.7).delay(0.2), value: isAnimating )
            
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8 , height: 8)
                    .offset(
                        x: 120 * cos(Double(index) * .pi / 4),
                        y: 120 * sin(Double(index) * .pi / 4)
                    )
                    .scaleEffect(isAnimating ? 1 : 0)
                    .opacity(isAnimating ? 0.7 : 0)
                    .animation(
                        .easeInOut(duration: 1.5).delay(Double(index) * 0.1), value: isAnimating
                    )
            }
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing : 30) {
            //MARK:Images
            ZStack {
                switch page {
                case .browseMenu:
                    foodImagesGroup
                case.quickDelivery:
                    deliverAnimation
                case.orderTracking:
                    orderTrackingAnimation
                }
            }
            // Text Content...
            VStack(spacing : 30) {
                Text(page.title)
                    .font(.system(.largeTitle , design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal )
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                Text(page.description)
                    .font(.system(.title3 , design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal  , 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
        }
        .padding(.top , 50 )
    }
}

#Preview {
    OnboardingView()
}
