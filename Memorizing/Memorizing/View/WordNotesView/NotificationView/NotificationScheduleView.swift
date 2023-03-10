//
//  NotificationScheduleView.swift
//  Memorizing
//
//  Created by μ§νμ on 2023/01/30.

import SwiftUI

struct NotificationScheduleView: View {
    @EnvironmentObject var notiManager: NotificationManager
    @State private var isShownDeleteAlert: Bool = false
    @State private var toBeDeleted: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("π‘λΈνΈλ³ μλ¦Όμ μ€μ ν΄λ³΄μΈμ!")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.leading, 20)
                .padding(.horizontal, 5)
                .padding(.top, 10)
            List {
                ForEach(Array($notiManager.pendingRequests.enumerated()), id: \.offset) {index, $request in
                    HStack {
                        ScheduleCell(pendingRequest: $request)
                            .listRowSeparator(.hidden)
                            .padding(.horizontal, 5)
                        Spacer()
                        
                        Button {
                            isShownDeleteAlert.toggle()
                            toBeDeleted = index
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.gray3)
                                .font(.title2)
                        }
                    }
                }
            }
            .listStyle(.plain)
        } // VStack
        .customAlert(isPresented: $isShownDeleteAlert,
                     title: "λ³΅μ΅ μλ¦Ό μ­μ ",
                     message: "μ΄λ² νμ°¨μ λ³΅μ΅ μλ¦Όμ μ­μ νμλ©΄ λ€μ μ€μ ν  μ μμ΄μ!",
                     primaryButtonTitle: "μλ¦Ό μ­μ ",
                     primaryAction: {
            if let deleteIndex = toBeDeleted {
                let removeItem: UNNotificationRequest = notiManager.pendingRequests[deleteIndex]
                notiManager.removeRequest(withIdentifier: removeItem.identifier)
            }
        },
                     withCancelButton: true,
                     cancelButtonText: "μ·¨μ")
        .task {
            for noti in notiManager.pendingRequests {
                print("μμ λ μλ¦Ό: \(noti.identifier)")
            }
        }
        .navigationTitle("μμ  μλ¦Ό")
    } // body
}

struct NotificationScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScheduleView()
            .environmentObject(NotificationManager())
    }
    
}
