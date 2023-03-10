//
//  NewMakeMemoryNote.swift
//  Memorizing
//
//  Created by 염성필 on 2023/01/05.
//

import SwiftUI

var noteCategories: [String] = ["영어", "한국사", "IT", "경제", "시사", "기타"]

var noteCategoryColor: [
    Color] = [
        Color("EnglishColor"),
        Color("HistoryColor"),
        Color("ITColor"),
        Color("EconomyColor"),
        Color("KnowledgeColor"),
        Color("EtcColor")
    ]

struct NewMakeMemoryNote: View {
    
    // MARK: - 재혁 추가 (취소, 등록 시 창을 나가는 dismiss())
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var myNoteStore: MyNoteStore
    @EnvironmentObject var marketStore: MarketStore
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var coreDataStore: CoreDataStore
    @Binding var isShowingNewMemorySheet: Bool
    
    // 글자수 제한을 위한 manager 선언 -> 내부에 noteName 변수를 manager.noteName으로 선언함
    @StateObject var manager = TFManamger()

    @Binding var isToastToggle: Bool

    // 카테고리를 눌렀을때 담기는 변수
    @State private var noteCategory: String = ""
    @State private var categoryColorIndex: Int = 0
    
    // MARK: - 총 3개 뷰 (상단 Header / 암기장 타이틀 입력 / 카테고리 선택)
    var body: some View {
        VStack(spacing: 40) {
            // 새로운 암기장 만들기
            makeNewNote
            // 암기장 이름
            noteTitle
            
            Spacer()
            // 버튼
            makeNoteButton
        }
        .padding()
    }
    
    // 최상단 (새로운 암기장 만들기 ~ X 표시)
    var makeNewNote: some View {
        HStack {
            VStack {
                // 아무 버튼도 아님
                Button {
                    //
                } label: {
                    Text("")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.mainBlack)
                }
            }
            .frame(width: 30)
            
            Spacer()
            
            VStack {
                Text("새로운 암기장 만들기")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .frame(width: 200)
            
            Spacer()
            
            VStack {
                Button {
                    isShowingNewMemorySheet.toggle()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.mainBlack)
                }
            }
            .frame(width: 30)
            
        }
    }
    
    // MARK: - 암기장 제목 / 카테고리 두개요소 묶음
    var noteTitle: some View {
        VStack(alignment: .leading, spacing: 40) {
            VStack(alignment: .leading) {
                Text("암기장 이름")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 10)
                TextField("암기장 제목을 입력해주세요(필수)", text: $manager.noteName)
                    .padding(15)
                    .padding(.leading, 3)
                    .accentColor(.mainBlue)
                    .lineLimit(3...5)
                    .background(Color.gray6)
                    .cornerRadius(20, corners: .allCorners)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .onAppear {
                        UIApplication.shared.hideKeyboard()
                    }
                // 글자수 제한 표시
                HStack {
                    Spacer()
                    Text("\(manager.noteName.count)/20")
                        .font(.caption)
                        .foregroundColor(manager.noteName.count == 0 ? Color.gray3 : Color.mainBlue)
                        .padding(.trailing)
                        .padding(.top, 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("카테고리")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 6)
                
                // MARK: - 버튼 눌리는 색상 표시 외 레이아웃 변경
                HStack {
                    ForEach(Array(zip(noteCategories.indices, noteCategories)), id: \.0) { (index, category) in
                        Button {
                            noteCategory = category
                        } label: {
                            Text("\(category)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(
                                    noteCategory == category ? Color.white : Color.gray4)
                        }
                        .frame(width: 53, height: 30)
                        .background {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(noteCategory == category ? noteCategoryColor[index] : Color.white)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(noteCategory == category ? noteCategoryColor[index] : Color.gray4)
                        }
                        
                    }
                }
            }
        }
    }
    
    // 하단 ( 버튼 )
    var makeNoteButton: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(!manager.noteName.isEmpty && !noteCategory.isEmpty ? .blue : .gray4)
            .frame(height: 55)
            .overlay {
                Button {
                    let id = UUID().uuidString
                    myNoteStore.myNotesWillBeSavedOnDB(
                        wordNote: MyWordNote(id: id,
                                             noteName: manager.noteName,
                                             noteCategory: noteCategory,
                                             enrollmentUser: authStore.user?.id ?? "",
                                             repeatCount: 0,
                                             firstTestResult: 0,
                                             lastTestResult: 0,
                                             updateDate: Date.now
                        )
                    )
                    
                    // coreData에 저장
                    coreDataStore.addNote(id: id,
                                          noteName: manager.noteName,
                                          enrollmentUser: authStore.user?.id ?? "No Enrollment User",
                                          noteCategory: noteCategory,
                                          firstTestResult: 0,
                                          lastTestResult: 0,
                                          updateDate: Date(),
                                          nextStudyDate: nil)
                    
                    isToastToggle = true
                    
                    isShowingNewMemorySheet = false
                } label: {
                    Text("새로운 암기장 만들기")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .disabled(!manager.noteName.isEmpty && !noteCategory.isEmpty ? false : true)
    }
    // MARK: - 글자수 제한(20자) 메서드, NoteName(암기장 이름) 변수를 여기서 선언함
    class TFManamger: ObservableObject {
        @Published var noteName = "" {
            
            didSet {
                // noteName의 길이가 20개 이상이거나, oldValue의 NoteCount가 20이하일 경우
                // noteName은 oldValue로 설정함! (즉, 20자 미만으로 설정)
                if noteName.count > 20 && oldValue.count <= 20 {
                    noteName = oldValue
                }
            }
        }
    }
}

struct NewMakeMemoryNote_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NewMakeMemoryNote(isShowingNewMemorySheet: .constant(true),
                              isToastToggle: .constant(true))
        }
    }
}
