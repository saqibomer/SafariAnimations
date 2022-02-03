//
//  Home.swift
//  Web
//
//  Created by Saqib Omer on 29/01/2022.
//

import SwiftUI

struct OpenedTabsView: View {
    
    //Color Scheme
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode
    
    // Sample Tabs
    @State var tabs: [Tab]
    
    
        
    var onAddNewTab: ((Bool) -> Void)?
    
    
    var body: some View {
        ZStack {
            //bg
            GeometryReader{proxy in
                let size = proxy.size
                
                Image("new")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(0)
            }
            .overlay((scheme == .dark ? Color.black : Color.white).opacity(0.35))
            .overlay(.ultraThinMaterial)
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                //Lazy Grid
                let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                
                LazyVGrid(columns: columns,spacing: 15) {
                    
                    //Tabs
                    ForEach(tabs) { tab in
                        
                        
                        // Tab Card View
                        TabCardView(tab: tab, tabs: $tabs)
                        
                    }
                    
                }
                .padding()
                
            }
            .safeAreaInset(edge: .bottom) {
                
                HStack {
                    
                    Button {
                        withAnimation{
                            onAddNewTab?(false)
                            presentationMode.wrappedValue.dismiss()
//                            tabs.append(Tab(tabURL: urls.randomElement() ?? ""))
                        }
                         
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        presentationMode.wrappedValue.dismiss()
                    } label : {
                        Text("Done")
                            .fontWeight(.semibold)
                    }
                }
                
                .overlay(
                    Button(action: {
                        
                    }, label: {
                        HStack(spacing: 4) {
                            Text("Private")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.primary)
                    })
                )
                
                .padding([.horizontal,.top])
                .padding(.bottom, 10)
                .background(
                    scheme == .dark ? Color.black : Color.white
                )
            }
            
        }
        
        
    }
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        OpenedTabsView()
//            .preferredColorScheme(.dark)
//    }
//}





// Sample Urls
var urls: [String] = [
    "https://unsplash.com/s/photos/animation",
    "https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html",
    "https://www.google.com",
    "https://www.youtube.com",
    "https://www.gmail.com",
    
]
