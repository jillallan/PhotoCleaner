//
//  YearView.swift
//  PhotoCleaner
//
//  Created by Jill Allan on 25/04/2025.
//

import SwiftUI

struct YearView: View {
    var photoCollection = PhotoCollection(collectionType: .all)
    @State var selectedYear: Int?

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    YearView()
}
