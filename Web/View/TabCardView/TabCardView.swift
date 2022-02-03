//
//  TabCardView.swift
//  Web
//
//  Created by TOxIC on 03/02/2022.
//

import SwiftUI

struct TabCardView: View {
    var tab: Tab
    
    //Tab Title
    //All Tabs
    @Binding var tabs: [Tab]
    @State var tabTitle = ""
    
    //Gestures
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var scale: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            // WebView
            WebView(tab: tab) { title in
                self.tabTitle = title
            }
                .frame(height: 250)
                .overlay(Color.primary.opacity(0.01))
                .cornerRadius(15)
                .overlay(
                    Button(action: {
                        withAnimation{
                            offset = -(getRect().width + 200)
                            removeTab()
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(.ultraThinMaterial,in: Circle())
                    })
                        .padding(10),
                    alignment: .topTrailing
                )
            Text(tabTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .frame(height: 50)
        }
        .scaleEffect(scale)
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
                                removeTab()
                            }
                            
                        }else {
                            withAnimation{
                                offset = 0
                            }
                        }
                    }
                    
                    
                })
        )
        .onAppear {
            let baseAnimation = Animation.spring()
                        

                        withAnimation(baseAnimation) {
                            scale = 1.0
                        }
                    }
        
        
    }
    
//    func getScale() {
//        //Scaling little bit while dragging
//        let progress = (offset > 0 ? offset : -offset) / 50
//
//        let scaleValue = (progress < 1 ? progress : 1) * 0.08
//        scale = 1 + scaleValue
//    }
    
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
