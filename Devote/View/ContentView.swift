//
//  ContentView.swift
//  Devote
//
//  Created by Hassan Assiry on 09/04/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    @State var task : String = ""
    @State private var showNewTaskItem : Bool = false
    @AppStorage("isDarkMode") private var isDarkMode : Bool = false
    

    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    

    // MARK: - FUNCTION
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    init?(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    // MARK: - HEADER
                    HStack(spacing: 10) {
                        // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading,4)
                        Spacer()
                        // EDIT btn
                        EditButton()
                            .font(.system(size: 16,weight: .semibold,design: .rounded))
                            .padding(.horizontal,10)
                            .frame(minWidth: 70,minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white ,lineWidth:2)
                            )
                        // APPERANCE btn
                        Button {
                            //toggel apperance
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24,height: 24)
                                .font(.system(.title,design: .rounded))
                            
                        }

                    }//: H-STACK
                    .padding()
                    .foregroundColor(.white)
                    Spacer(minLength: 80)
                    // MARK: - NEW TASK BUTTON
                    Button {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)

                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30 , weight: .semibold , design: .rounded))
                        Text("new Task")
                            .font(.system(size: 24 , weight: .bold , design: .rounded))

                    }
                    .foregroundColor(.white)
                    .padding(.horizontal , 20)
                    .padding(.vertical , 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.red , Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25),radius: 8)
                    
                    // MARK: - TASKS
                    List {
                            ForEach(items) { item in
                                ListRowItemView(item: item)
                            }
                            .onDelete(perform: deleteItems)
                        }//:LIST
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.3), radius: 12 , x:0 , y:0)
                    .padding(.vertical,0)
                    .frame(maxWidth: 640)
                    
                   }//: V-STACK
                .blur(radius: showNewTaskItem ? 6.5 : 0 , opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: 1)
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? Color.black : Color.gray
                              , backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView( isShowing: $showNewTaskItem)
                }
              }//: Z-STACK
            .background(
            BackgroundImageView()
                .blur(radius: showNewTaskItem ? 8 : 0 , opaque: false)

            )
            .background(
                backgroundGradient.ignoresSafeArea(.all)
            )
            .onAppear(){
                UITableView.appearance().backgroundColor = .clear
            }
            .navigationBarTitle("Daily Tasks",displayMode: .large)
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
              }//: TOOLBAR
           
            }//:NAVIGATION
            .navigationViewStyle(StackNavigationViewStyle())
            
         }
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
