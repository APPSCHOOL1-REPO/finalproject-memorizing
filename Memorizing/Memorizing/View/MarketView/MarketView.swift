//
//  MarketView.swift
//  Memorizing
//
//  Created by 진준호 on 2023/01/05.
//

import SwiftUI

enum SortCategory: String {
    case nomalSort
    case salesCount
    case starScoreTotal
    case reviewCount
    case recentUpdate
}

// MARK: - 마켓 탭에서 가장 메인으로 보여주는 View
struct MarketView: View {
    @EnvironmentObject var marketStore: MarketStore
    @EnvironmentObject var authStore: AuthStore
    /// 검색창 입력 텍스트
    @State private var searchText: String = ""
    @State private var isSheetOpen: Bool = false
    @State private var isToastToggle: Bool = false
    @State private var isPointTap: Bool = false
    
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    @State private var index: Int = 0
    
    /// 카테고리 목록
    static let categoryArray: [String] = [
        "전체", "영어", "한국사", "IT", "경제", "시사", "기타"
    ]
    
    static let colorArray: [Color] = [
        .mainDarkBlue, .mainBlue, .historyColor, .iTColor, .economyColor, .knowledgeColor, .etcColor
    ]
    
    @State private var selectedCategory: String  = "전체"
    @State private var selectedSortCategory: SortCategory = .nomalSort
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // MARK: - 검색창
                MarketViewSearchBar(searchText: $searchText)
                    .padding(.top, 15)
                
                // MARK: - 카테고리 버튼들
                MarketViewCategoryButton(selectedCategory: $selectedCategory,
                                         categoryArray: MarketView.categoryArray)
//                .frame(width: UIScreen.main.bounds.width * 0.9,
//                       height: UIScreen.main.bounds.height * 0.05)
                
                // MARK: - 정렬기준 선택하기
                HStack(spacing: 10) {
                    Spacer()
                    
                    MarketSortButton(selectedSortCategory: selectedSortCategory,
                                     categoryState: .starScoreTotal,
                                     sortTitle: "평점순")
                    .onTapGesture {
                        if self.selectedSortCategory == .starScoreTotal {
                            self.selectedSortCategory = .nomalSort
                        } else {
                            self.selectedSortCategory = .starScoreTotal
                        }
                    }
                    
                    MarketSortButton(selectedSortCategory: selectedSortCategory,
                                     categoryState: .reviewCount,
                                     sortTitle: "리뷰순")
                    .onTapGesture {
                        if self.selectedSortCategory == .reviewCount {
                            self.selectedSortCategory = .nomalSort
                        } else {
                            self.selectedSortCategory = .reviewCount
                        }
                    }
                    
                    MarketSortButton(selectedSortCategory: selectedSortCategory,
                                     categoryState: .salesCount,
                                     sortTitle: "판매순")
                    .onTapGesture {
                        if self.selectedSortCategory == .salesCount {
                            self.selectedSortCategory = .nomalSort
                        } else {
                            self.selectedSortCategory = .salesCount
                        }
                    }
                    
                    MarketSortButton(selectedSortCategory: selectedSortCategory,
                                     categoryState: .recentUpdate,
                                     sortTitle: "최신순")
                    .onTapGesture {
                        if self.selectedSortCategory == .recentUpdate {
                            self.selectedSortCategory = .nomalSort
                        } else {
                            self.selectedSortCategory = .recentUpdate
                        }
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 3)
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        // MARK: - Grid View
                        
                        let columns = [
                            GridItem(.flexible(), spacing: 10, alignment: nil),
                            GridItem(.flexible(), spacing: 10, alignment: nil)
                        ]
                        
                        LazyVGrid(
                            columns: columns,
                            spacing: 18,
                            content: {
                                switch selectedSortCategory {
                                case .nomalSort:
                                    ForEach(marketStore.marketWordNotes) { wordNote in
                                        if searchText.isEmpty
                                            || wordNote.noteName.contains(searchText)
                                            || wordNote.noteName.contains(searchText.uppercased())
                                            || wordNote.noteName.contains(searchText.lowercased()) {
                                            MarketViewNoteButton(isSheetOpen: $isSheetOpen,
                                                                 selectedCategory: $selectedCategory,
                                                                 selectedWordNote: wordNote)
                                        }
                                    }
                                case .salesCount:
                                    ForEach(marketStore.marketWordNotes.sorted{ $0.salesCount > $1.salesCount }) { wordNote in
                                        if searchText.isEmpty
                                            || wordNote.noteName.contains(searchText)
                                            || wordNote.noteName.contains(searchText.uppercased())
                                            || wordNote.noteName.contains(searchText.lowercased()) {
                                            MarketViewNoteButton(isSheetOpen: $isSheetOpen,
                                                                 selectedCategory: $selectedCategory,
                                                                 selectedWordNote: wordNote)
                                        }
                                    }
                                case .starScoreTotal:
                                    ForEach(marketStore.marketWordNotes.sorted{ ($0.starScoreTotal / Double($0.reviewCount == 0 ? 100 : $0.reviewCount)) > ($1.starScoreTotal / Double($1.reviewCount == 0 ? 100 : $1.reviewCount)) }) { wordNote in
                                        if searchText.isEmpty
                                            || wordNote.noteName.contains(searchText)
                                            || wordNote.noteName.contains(searchText.uppercased())
                                            || wordNote.noteName.contains(searchText.lowercased()) {
                                            MarketViewNoteButton(isSheetOpen: $isSheetOpen,
                                                                 selectedCategory: $selectedCategory,
                                                                 selectedWordNote: wordNote)
                                        }
                                    }
                                case .reviewCount:
                                    ForEach(marketStore.marketWordNotes.sorted{ $0.reviewCount > $1.reviewCount }) { wordNote in
                                        if searchText.isEmpty
                                            || wordNote.noteName.contains(searchText)
                                            || wordNote.noteName.contains(searchText.uppercased())
                                            || wordNote.noteName.contains(searchText.lowercased()) {
                                            MarketViewNoteButton(isSheetOpen: $isSheetOpen,
                                                                 selectedCategory: $selectedCategory,
                                                                 selectedWordNote: wordNote)
                                        }
                                    }
                                case .recentUpdate:
                                    ForEach(marketStore.marketWordNotes.sorted{ $0.updateDate > $1.updateDate }) { wordNote in
                                        if searchText.isEmpty
                                            || wordNote.noteName.contains(searchText)
                                            || wordNote.noteName.contains(searchText.uppercased())
                                            || wordNote.noteName.contains(searchText.lowercased()) {
                                            MarketViewNoteButton(isSheetOpen: $isSheetOpen,
                                                                 selectedCategory: $selectedCategory,
                                                                 selectedWordNote: wordNote)
                                        }
                                    }
                                }
                            })
                        .padding(.horizontal)
                        .padding(.top, 1)
                        .padding(.bottom, 120)
                    }   // ScrollView end
                    .padding(.bottom, 1)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Image("Logo")
                                .resizable()
                                .frame(width: 35, height: 22)
                                .padding(.leading, 10)
                        }
                        ToolbarItem(placement: .principal) {
                            Text("암기장 마켓")
                                .font(.title3.bold())
                                .accessibilityAddTraits(.isHeader)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.mainBlue)
                                .frame(width: 60, height: 30)
                                .overlay {
                                    Text("\(authStore.user?.coin ?? 0)P")
                                        .foregroundColor(.mainBlue)
                                        .font(.subheadline)
                                }
                                .onTapGesture {
                                isPointTap.toggle()
                                }
                        }
                    }
                    .fullScreenCover(isPresented: $isSheetOpen) {
                        // TODO: 단어장 클릭시 단어 목록 리스트 보여주기
                        MarketViewSheet(wordNote: marketStore.sendWordNote,
                                        isToastToggle: $isToastToggle)
                    }
                }
            }
            
            NavigationLink(destination: MarketViewAddButton()) {
                Circle()
                    .foregroundColor(.mainBlue)
                    .frame(width: 65, height: 65)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                    }
                    .shadow(radius: 1, x: 1, y: 1)
            }
            .offset(x: UIScreen.main.bounds.width * 0.36,
                    y: UIScreen.main.bounds.height * 0.33)
        }
        .customToastMessage(isPresented: $isToastToggle,
                            message: "구매가 완료되었습니다!",
                            delay: 0)
        .refreshable {
            Task {
                await marketStore.marketNotesWillFetchDB()
            }
        }
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
        .customAlert(isPresented: $isPointTap,
                     title: "포인트를 얻는 방법",
                     message: "1. 4번의 학습을 완료하고 도장을 받아봐요~!\n2. 사람들에게 나만의 암기장을 판매해봐요~!\n3. 구매한 암기장에 리뷰를 작성해봐요~!",
                     primaryButtonTitle: "확인",
                     primaryAction: {
        },
                     withCancelButton: false,
                     cancelButtonText: "아니요")
    }
}

struct MarketSortButton: View {
    var selectedSortCategory: SortCategory
    var categoryState: SortCategory
    var sortTitle: String
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(selectedSortCategory == categoryState ? .mainDarkBlue : .gray4)
            
            Text(sortTitle)
                .bold()
                .font(.caption)
                .foregroundColor(selectedSortCategory == categoryState ? .mainDarkBlue : .gray4)
        }
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MarketView()
                .environmentObject(MarketStore())
                .environmentObject(AuthStore())
        }
    }
}
