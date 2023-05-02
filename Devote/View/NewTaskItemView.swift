//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Hassan Assiry on 17/04/2023.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - PROPERTY
    @AppStorage("isDarkMode") private var isDarkMode : Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @State var task : String = ""
    @Binding var isShowing : Bool
    
    private var isButtonDisable : Bool {
        task.isEmpty
    }
    
    // MARK: - Functions
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.id = UUID()
            newItem.completion = false

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }

    // MARK: - BODY
    var body: some View {
        VStack{
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24 , weight: .bold , design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ?  Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                Button {
                    addItem()
                    playSound(sound: "sound-ding", type: "mp3")
                    feedback.notificationOccurred(.success)
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24 , weight: .bold , design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisable)
                .onTapGesture {
                    if isButtonDisable {
                        playSound(sound: "sound-tap", type: "mp3")  
                    }
                }
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(isButtonDisable ? Color.blue : Color.pink)
                    .cornerRadius(10)

            }//: V-Stack
            .padding(.horizontal)
            .padding(.vertical,20)
            .background(
                isDarkMode ?  Color(UIColor.secondarySystemBackground) : Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.65),radius: 24)
            .frame(maxWidth: 640)
        }//: V-STACK
        .padding()
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView( isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
