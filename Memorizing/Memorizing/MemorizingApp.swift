//
//  MemorizingApp.swift
//  Memorizing
//
//  Created by 진준호 on 2023/01/05.
//

import SwiftUI
import FirebaseCore
import KakaoSDKAuth
import KakaoSDKCommon
import Firebase
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
    
    // 세로모드로 설정 
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

@main
struct MemorizingApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - ScenePhase 선언
    @Environment(\.scenePhase) var scenePhase
    @StateObject var authStore: AuthStore = AuthStore()
    @StateObject var myNoteStore: MyNoteStore = MyNoteStore()
    @StateObject var marketStore: MarketStore = MarketStore()
    @StateObject var reviewStore: ReviewStore = ReviewStore()
    @StateObject var notiManager: NotificationManager = NotificationManager()
    @StateObject var coreData: CoreDataStore = CoreDataStore()
    init() {
        // Kakao SDK 초기화
        let KAKAO_APP_KEY: String = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String ?? "KAKAO_APP_KEY is nil"
        KakaoSDK.initSDK(appKey: KAKAO_APP_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            
            SplashView()
                .environmentObject(authStore)
                .environmentObject(myNoteStore)
                .environmentObject(marketStore)
                .environmentObject(reviewStore)
                .environmentObject(notiManager)
                .environmentObject(coreData)
                .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                    // 카카오 로그인을 위해 웹 혹은 카카오톡 앱으로 이동 후 다시 앱으로 돌아오는 과정을 거쳐야하므로, Handler를 추가로 등록해줌
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .onChange(of: scenePhase) { newValue in
                    if newValue == .active {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                        UserDefaults.standard.set(0, forKey: UserDefaults.Keys.notificationBadgeCount.rawValue)
                    }
                }
        }
    }
}
