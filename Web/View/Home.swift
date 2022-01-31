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
                        TabCardView(tab: tab, tabs: $tabs)
                        
                    }
                    
                }
                .padding()
                
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
struct TabCardView: View {
    var tab: Tab
    
    //Tab Title
    //All Tabs
    @Binding var tabs: [Tab]
    @State var tabTitle = ""
    
    //Gestures
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    
    var body: some View {
        VStack(spacing: 10) {
            // WebView
            WebView(tab: tab) { title in
                self.tabTitle = title
            }
                .frame(height: 250)
                .overlay(Color.primary.opacity(0.01))
                .cornerRadius(15)
            Text(tabTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(height: 50)
        }
        .scaleEffect(getScale())
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    // Safety
                    if isDragging {
                        let translation = value.translation.width
                        offset = translation > 0 ? translation / 10 : translation
                    }
                })
                .onEnded({ value in
                    
                    let translation = value.translation.width > 0 ? 0 : -value.translation.width
                    // left side one translation width for removal
                    // right side one
                    if getIndex() % 2 == 0 {
                        print("Left")
                        if translation > 100 {
                            // moving tab aside nd removing it
                            withAnimation{
                                offset = -(getRect().width + 200)
                                removeTab()
                            }
                        }else {
                            withAnimation{
                                offset = 0
                            }
                        }
                    } else {
                        print("Right")
                        if translation > getRect().width - 150 {
                            
                            withAnimation{
                                offset = -(getRect().width + 200)
                            }
                            
                        }else {
                            withAnimation{
                                offset = 0
                            }
                        }
                    }
                    
                    
                })
        )
    }
    
    func getScale()->CGFloat {
        //Scaling little bit while dragging
        let progress = (offset > 0 ? offset : -offset) / 50
        
        let scale = (progress < 1 ? progress : 1) * 0.08
        return 1 + scale
    }
    
    func getIndex()->Int {
        let index = tabs.firstIndex{ currentTab in
            return currentTab.id == tab.id
        } ?? 0
        return index
    }
    
    func removeTab() {
        // Safe Remove
        tabs.removeAll{ tab in
            return self.tab.id ==  tab.id
            
            
        }
    }
}

// Extension WebView to get Screen Bounds
extension View {
    func getRect()-> CGRect {
        return UIScreen.main.bounds
    }
}
