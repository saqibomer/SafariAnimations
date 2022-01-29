//
//  Home.swift
//  Web
//
//  Created by Saqib Omer on 29/01/2022.
//

import SwiftUI

struct Home: View {
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
            .ignoresSafeArea()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
