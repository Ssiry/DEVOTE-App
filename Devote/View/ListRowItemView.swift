//
//  ListRowItemView.swift
//  Devote
//
//  Created by Hassan Assiry on 19/04/2023.
//

import SwiftUI

struct ListRowItemView: View {
    // MARK: - PROPERTY
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item : Item
    // MARK: - BODY
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical,12)
                .animation(.default, value: 1)
        }//: TOGGLE
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange, perform:  { _ in
            if self.viewContext.hasChanges{
                try? self.viewContext.save()
            }
        }
                   )
    }
}

//struct ListRowItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListRowItemView( item: Item())
////            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
// 
