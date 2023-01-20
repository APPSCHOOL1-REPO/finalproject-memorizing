//
//  StudyingStampView.swift
//  Memorizing
//
//  Created by 김혜지 on 2023/01/20.
//

import SwiftUI

struct StudyingStampView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var myNoteStore: MyNoteStore
    @EnvironmentObject var notiManager: NotificationManager
    var wordNote: MyWordNote
    @Binding var isDismiss: Bool
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 5) {
                Text("복습 완료")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("복습을 마무리했어요!다음 복습때 만나요!")
                    .font(.footnote)
            }
            .frame(width: 320, alignment: .leading)
            .padding(.bottom, 10)
            .padding(.leading, 5)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Gray4"), lineWidth: 1)
                    .foregroundColor(.white)
                    .overlay {
                        Image("studyicon")
                            .resizable()
                            .frame(width: 200, height: 200)
                    }
            }
            .frame(width: 330, height: 330)
            .padding(.bottom)
            
            Button {
                Task {
                    await myNoteStore.repeatCountWillBePlusOne(wordNote: wordNote)
                    
                    // 알림 설정 권한 확인
                    if !notiManager.isGranted {
                        notiManager.openSetting()  // 알림 설정 창
                    } else if notiManager.isGranted && (wordNote.repeatCount + 1) < 4 { // 알림 추가
                        print("set localNotification")
                        var localNotification = LocalNotification(
                            identifier: UUID().uuidString,
                            title: "MEMOrizing 암기 시간",
                            body: "\(wordNote.repeatCount + 1)번째 복습할 시간이에요~!",
                            timeInterval: Double(wordNote.repeatCount * 1),
                            repeats: false
                        )
                        localNotification.subtitle = "\(wordNote.noteName)"
                        print("localNotification: ", localNotification)
                        
                        await notiManager.schedule(localNotification: localNotification)
                        await notiManager.getPendingRequests()
                    }
                    isDismiss.toggle()
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("MainDarkBlue"))
                    .frame(width: 330, height: 50)
                    .overlay {
                        Text("종료 하기")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("구매한 암기장은 어떠셨나요?")
                    Text("후기를 작성해보시면 10P을 드립니다!")
                }.font(.caption) .foregroundColor(.gray2)
                Spacer()
                
                Button {
                    // 후기작성
                } label: {
                    HStack {
                        Text("후기 작성 하기")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline) .fontWeight(.semibold)
                }
            }
            .frame(width: 320, alignment: .leading)
            .padding(.top, 20)
        }
    }
}

// struct StudyingStampView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyingStampView(wordNote: MyWordNote(id: "1",
//                                               noteName: "hi",
//                                               noteCategory: "경제",
//                                               enrollmentUser: "",
//                                               repeatCount: 1,
//                                               firstTestResult: 1.0,
//                                               lastTestResult: 0,
//                                               updateDate: Date()),
//                          isDismiss: .constant(false))
//    }
// }