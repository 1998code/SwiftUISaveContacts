/*
    ContentView.swift (Shared)
    Abstract: SwiftUI sample #2022Winter - How to use Contacts API to save contacts.
    Created by Ming on 18/12/2021.
    Ref: https://developer.apple.com/documentation/contacts
*/

import SwiftUI
import CoreData
import Contacts

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Created at \(item.timestamp!, formatter: itemFormatter)").padding()
                        VStack(spacing:15) {
                            Text("Details: \(item.name!) \(Text(item.phone!).foregroundColor(.green))")
                        }.padding()
                        Button("+ Add to Contacts") {
                            // Create a mutable object to add to the contact.
                            // Mutable object means an object state that can be modified after created.
                            let contact = CNMutableContact()
                            // Name
                            contact.givenName = item.name!
                            // Phone No.
                            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: item.phone!))]
                            // Save the created contact.
                            let store = CNContactStore()
                            let saveRequest = CNSaveRequest()
                            saveRequest.add(contact, toContainerWithIdentifier: nil)
                            do {
                                try store.execute(saveRequest)
                            } catch {
                                print("Error occur: \(error)")
                                // Handle error
                                // may add a alert...
                            }
                        }.buttonStyle(.borderedProminent)
                        .tint(.black)
                    } label: {
                        ZStack {
                            ForEach((0...2), id: \.self) {
                                Circle().frame(width: CGFloat(25-$0*5)).foregroundColor(.blue)
                                Circle().frame(width: CGFloat(23-$0*5)).foregroundColor(.white)
                            }
                        }
                        VStack (alignment:.leading) {
                            Text(item.name!)
                            Text("Created at \(item.timestamp!, formatter: itemFormatter)").font(.caption)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: .constant(""))
            .navigationTitle("SwiftUI")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addItem) {
                        HStack {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            Text("Select an item") // For iPad
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
