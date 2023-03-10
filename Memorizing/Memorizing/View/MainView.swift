//
//  TabView.swift
//  Memorizing
//
//  Created by 진준호 on 2023/01/05.
//

import SwiftUI
import FirebaseAuth

// MARK: 암기장, 마켓, 마이페이지를 Tab으로 보여주는 View
struct MainView: View {
    @State private var tabSelection = 1
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var marketStore: MarketStore
    @EnvironmentObject var myNoteStore: MyNoteStore
    @State var isFirstLogin: Bool = false
    @AppStorage("firstLogin") private var firstLogin: Bool?
    
    var body: some View {
        // TODO: - 로그인 처음 화면에서 이름 바꿔주는 창 띄우기
        TabView(selection: $tabSelection) {
            NavigationStack {
                WordNotesView()
            }.tabItem {
                VStack {
                    Image(systemName: "note.text")
                    Text("암기장")
                }
            }
            .tag(1)
            
            NavigationStack {
                MarketView()
            }.tabItem {
                VStack {
                    Image(systemName: "basket")
                    Text("마켓")
                }
            }
            .tag(2)
            .overlay {
                // 최초 로그인시에만 보이는 튜토리얼 화면
                if firstLogin == nil {
                    Color.black
                        .opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            Text("내 암기장을 판매하여 포인트를 얻을 수 있어요")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .offset(x: UIScreen.main.bounds.width * 0.02,
                                        y: UIScreen.main.bounds.height * 0.24)
                        }
                        .overlay {
                            Circle()
                                .foregroundColor(.mainBlue)
                                .frame(width: 85, height: 85)
                                .overlay {
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .bold()
                                }
                                .shadow(radius: 1, x: 1, y: 1)
                                .offset(x: UIScreen.main.bounds.width * 0.36,
                                        y: UIScreen.main.bounds.height * 0.3525)
                        }
                        .onTapGesture {
                            // 1초 뒤부터 onTapGesture 활성화 되도록 함
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                firstLogin = true
                            }
                        }
                }
            }
            
            NavigationStack {
                MyPageView()
            }.tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("마이페이지")
                }
            }
            .tag(3)
        }
        .task {
            await authStore.userInfoWillFetchDB()
            await marketStore.marketNotesWillFetchDB()
            await marketStore.myNotesArrayWillFetchDB()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthStore())
            .environmentObject(MyNoteStore())
            .environmentObject(MarketStore())
    }
}
