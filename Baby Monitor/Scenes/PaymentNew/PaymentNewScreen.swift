//
//  PaymentNewScreen.swift
//  Baby Monitor
//
//  Created by Andreas on 31.08.2022.
//

import SwiftUI
import Adapty

struct PaymentNewScreen: View {
    
    let shouldShowCloseBtn: Bool
    @StateObject private var viewModel = PaymentNewVM()
    @Environment(\.presentationMode) var presentationMode
    @State var showLegals = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    if shouldShowCloseBtn {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(.closeBtn)
                        }
                    }

                    Spacer()
                    
                    Button {
                        viewModel.restore()
                    } label: {
                        Text("Restore")
                            .foregroundColor(.mainGray)
                    }
                }
                .padding()
                
                firstBlock
                
                Image(.theSecondBlock)
                    .padding(.bottom)

                thirdBlock
                
                foufthBlock
            
                Image(.foufthBlock)
                    .resizable()
                    .frame(height: 600)
                    .padding(.bottom)
                
                reviewsViews
                
                policy
                
                if viewModel.fetchingProducts {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                } else {
                    if viewModel.isActiveSub {
                        Text("You already have active subscription")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.green)
                            .padding(.vertical)
                    } else {
                        subs
                    }
                }
            }
        }
        .sheet(isPresented: $showLegals) {
            LegalsView()
        }
    } // body
    
    private var subs: some View {
        VStack {
            HStack {
                Text("Not sure yet? Enable 3-day free trial")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.mainGray)
                Spacer()
                Toggle("", isOn: $viewModel.isTrialEnabled)
                    .labelsHidden()
            }
            .padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.products, id: \.self) { product in
                        Button {
                            viewModel.makePurchase(with: product)
                        } label: {
                            productCellYearly(product)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func productCellYearly(_ product: ProductModel?) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("SAVE 70%")
                    .padding(4)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .background(product?.subscriptionPeriod?.unit == .year ? Color.mainOrange : Color.clear)
                    .cornerRadius(5, corners: [.bottomLeft, .topLeft, .topRight])
            }
            .offset(x: 1)
            
            VStack {
                ZStack {
                    Color.paleOrange
                    VStack {
                        Text(product?.localizedTitle ?? "")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.mainGray)
                        Text(product?.skProduct?.priceToString() ?? "")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.mainGray)
                    }
                }
                .frame(height: 71)
                .cornerRadius(18, corners: [.bottomLeft, .topLeft, .bottomRight])
                Spacer()
                
                let text = product?.subscriptionPeriod?.unit == .year ? "\(product?.skProduct?.priceToStringPerMonth() ?? "")/ month" : "1297 subscribers"
                Text(text)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .frame(width: 162, height: 111)
            .overlay(
                RoundedCorner(radius: 18, corners: [.bottomLeft, .topLeft, .bottomRight])
                    .stroke(product?.subscriptionPeriod?.unit == .year ? Color.mainOrange : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
        .padding(.leading)
    }
    
    private var firstBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .overlay(
                    LinearGradient(colors: [.lightYellow, .mainOrange], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(30)
                .padding()
            Image(.firstBlock)
                .resizable()
                .frame(height: 500)
                
            
        }
        .padding(.bottom)
    }
    
    private var thirdBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.lightPurple)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
                .padding()
                
            
            Image(.secondBlock)
        }
        .padding(.bottom)
    }
    
    private var foufthBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 500)
                .overlay(
                    LinearGradient(colors: [.preDarkPurple, .darkPurple], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(30)
                .padding()
            
            Image(.thirdBlock)
                .resizable()
                .frame(height: 500)
                .offset(y: 70)
                
        }
        .padding(.bottom, 76)
    }
    
    private var policy: some View {
        VStack {
            HStack(spacing: 20) {
                Button {
                    guard let url = URL(string: "http://babymonitordino.tilda.ws/terms") else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Text("Terms of use")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .underline()
                        .foregroundColor(.gray)
                }
                
                Button {
                    guard let url = URL(string: "http://babymonitordino.tilda.ws/privacy") else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Text("Privacy Police")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .underline()
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)
            
            Text(String.privacyTip)
                .font(.system(size: 11, weight: .light, design: .default))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private var reviewsViews: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(.star)
                Image(.star)
                Image(.star)
                Image(.star)
                Image(.star)
                Spacer()
            }
            .padding()
            
            Text("Trusted by thousands of parents around the world")
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(.mainGray)
                .padding(.bottom)
            
            Text("We pride ourselves on being rated 4.7 stars")
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
                .font(.system(size: 15, weight: .regular, design: .default))
                .padding(.bottom)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(reviews, id: \.self) { review in
                        VStack {
                            HStack {
                                Spacer()
                                Image(.quotes)
                                    .offset(x: -10, y: 18)
                            }
                            
                            VStack {
                                Text(review)
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(.mainGray)
                            }
                            .frame(width: 267, height: 143)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                        }
                        .padding(.leading, 16)
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

struct LegalsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LagalsVC {
        LagalsVC()
    }

    func updateUIViewController(_ uiViewController: LagalsVC, context: Context) {
    }
}

struct PaymentNewScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentNewScreen(shouldShowCloseBtn: true)
    }
}
