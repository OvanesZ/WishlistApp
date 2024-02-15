//
//  ReservedPresentForFriend.swift
//  Wishlist
//
//  Created by Ованес Захарян on 15.02.2024.
//

import SwiftUI

struct ReservedPresentForFriend: View {
    
    @StateObject var viewModel: ReservedPresentViewModel = ReservedPresentViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: true, presentDescription: ""))
    
    var testPresent: [PresentModel] = [
    PresentModel(id: "1", name: "Present 1", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "2", name: "Present 2", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "3", name: "Present 3", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "4", name: "Present 4", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "5", name: "Present 5", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "6", name: "Present 6", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "7", name: "Present 7", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1"),
    PresentModel(id: "8", name: "Present 8", urlText: "https://ozon.ru", presentFromUserID: "1", isReserved: true, presentDescription: "present 1")
    ]
    
    @State var statusPresent: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            
            List {
                ForEach(testPresent) { present in
                    NavigationLink {
                        Text(present.name)
                    } label: {
                        ReservedPresentCell(present: present, viewModel: viewModel, statusPresent: $statusPresent)
                    }
                    .swipeActions {
                        Button(action: {
                            statusPresent.toggle()
                        }, label: {
                            Text(statusPresent ? "Не выполнено" : "Выполнено")
                        })
                        .tint(statusPresent ? .red : .green)
                    }
                }
            }
            .listStyle(.inset)
            
            .navigationTitle("Подарки друзьям")
        }
        
        
    }
}

#Preview {
    ReservedPresentForFriend()
}


struct ReservedPresentCell: View {
    
    var image = UIImage(named: "person")!
    let present: PresentModel
    @ObservedObject var viewModel: ReservedPresentViewModel
    @Binding var statusPresent: Bool
    
    var body: some View {
        
        
        HStack {
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .overlay {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
                .opacity(50)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            
            
            VStack {
                HStack {
                    Text(present.name)
                        .font(.system(.headline, design: .rounded))
                    
                    Spacer()
                }
               
                HStack {
                    Text("Владелец пожелания")
                        .font(.system(.footnote, design: .rounded))
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
            }
            
            VStack {
                
                Text("Уже купил?")
                    .font(.footnote)
                
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(statusPresent ? .green : .red)
                    
                }
            }
        }
    }
}



class ReservedPresentViewModel: ObservableObject {
    
    let present: PresentModel
//    @Published var statusPresent = false
    
    init(present: PresentModel) {
        self.present = present
    }
    
    
    
}
