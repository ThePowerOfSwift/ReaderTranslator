//
//  StatusBarView_Voice.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            Text("Voice: ")
            StatusBarView_Voice_Select()
            StatusBarView_Voice_Favorite()
            StatusBarView_Voice_Volume()
        }
    }
}

struct StatusBarView_Voice_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice()
    }
}
