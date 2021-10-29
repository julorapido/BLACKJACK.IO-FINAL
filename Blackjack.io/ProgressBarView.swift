//
//  ProgressBarView.swift
//  vertical-progress-bar
//
//  Created by Alexandru Nistor on 11/10/16.
//  Copyright © 2016 ASSIST-Software. All rights reserved.
//  www.assist-software.net

import SwiftUI

struct ProgressBar: View{
    var width : CGFloat = 200
    var height: CGFloat = 20
    var percent: CGFloat = 69
    var color1 = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    var color2 = Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
    
    var body: some View{
        let multiplier = width / 100
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: width, height: height)
            .foregroundColor(Color.black.opacity(0.1))
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: percent * multiplier, height: height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    )
                .foregroundColor(.clear)
            
        }
    }

}

struct ProgressBar_Preview: PreviewProvider{
    static var previews: some View{
        ProgressBar()
    }
}
