//
//  Home.swift
//  Web
//
//  Created by Saqib Omer on 29/01/2022.
//

import SwiftUI

struct Home: View {
    
    //Color Scheme
    @Environment(\.colorScheme) var scheme
    
    // Sample Tabs
    @State var tabs: [Tab] = [
        .init(tabURL: "https://www.youtube.com/watch?v=qWO7PJ5Icwg"),
            .init(tabURL: "https://www.apple.com"),
    ]
    
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
                    }
                    
                }
                
            }
            .safeAreaInset(edge: .bottom) {
                
                HStack {
                    
                    Button {
                         
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Button {
                        
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}
