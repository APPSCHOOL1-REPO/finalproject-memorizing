//  MyMemoryNote.swift
//  Memorizing
//
//  Created by 염성필 on 2023/01/05.
//

import SwiftUI

// MARK: - 단어 등록 완료된 뷰
struct MyMemoryNote: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var myNoteStore: MyNoteStore
    @EnvironmentObject var coreDataStore: CoreDataStore
    var myWordNote: NoteEntity
    var words: [WordEntity] {
        myWordNote.words?.allObjects as? [WordEntity] ?? []
    }
    @State private var isShowingSheet: Bool = false
    @State private var opacityValue: Double = 0
    
    // 한 번도 안 하면 -1, 한 번씩 할 때마다 1씩 증가
    @State var progressStep: Int = 0
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray4, lineWidth: 1)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                
                HStack {
                    Rectangle()
                        .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                        .frame(width: UIScreen.main.bounds.width * 0.04)
                        .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    
                    VStack(spacing: 5) {
                        HStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""),
                                        lineWidth: 1)
                                .frame(width: 45, height: 23)
                                .overlay {
                                    Text(myWordNote.noteCategory ?? "No Category")
                                        .foregroundColor(.black)
                                        .font(.caption2)
                                }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        
                        // 암기할 것 등록하기에서 받아오기
                        HStack {
                            Text(myWordNote.noteName ?? "No Name")
                                .foregroundColor(.mainBlack)
                                .font(.body)
                                .fontWeight(.semibold)
                                .padding(.top, 5)
                                .padding(.leading, 6)
                                .padding(.bottom, 3)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 6)
                        .padding(.bottom, 10)
                        
                        if words.isEmpty {
                            Text("단어 등록하러 가기")
                                .font(.footnote)
                                .frame(width: UIScreen.main.bounds.width * 0.75,
                                       height: UIScreen.main.bounds.width * 0.06)
                                .foregroundColor(.white)
                                .background { coreDataStore.returnColor(category: myWordNote.noteCategory ?? "") }
                                .cornerRadius(30)
                                .opacity(opacityValue)
                        } else {
                            // MARK: 얼굴 진행도
                            FaceProgressView(myWordNote: myWordNote)
                                .opacity(opacityValue)
                                .padding(.leading, -5)
                        }
                    }
                    .padding(.vertical)
                }
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray2)
                            .fontWeight(.light)
                        Spacer()
                    }
                    .padding(.top, 25)
                }
                .padding(.trailing, 25)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .onTapGesture(perform: {
                isShowingSheet.toggle()
                
            })
            .fullScreenCover(isPresented: $isShowingSheet) {
                NavigationStack {
                    EditListView(wordNote: myWordNote)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    opacityValue = 1
                }
            }
        }
    }
}
