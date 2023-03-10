//
//  FaceProgressView.swift
//  Memorizing
//
//  Created by 윤현기 on 2023/01/06.
//

import SwiftUI

// MARK: 단어장 진행도 view
struct FaceProgressView: View {
    
    var myWordNote: NoteEntity
    @EnvironmentObject var coreDataStore: CoreDataStore
    // MARK: 진행도 배경 동그라미 크기
    @State private var backgroundCircleSize = UIScreen.main.bounds.width * 0.08
    // MARK: 진행도 숫자 or 얼굴 동그라미 크기
    @State private var numberCircleSize = UIScreen.main.bounds.width * 0.06
    
    /// 1,4회차 학습 성취도에 따라 표정 이모지 변경
    func returnTestResultFace(result: Double) -> String {
        var face: String = "FaceNormal"
        
        if result > 0 && result <= 0.5 {
            face = "FaceBad"
        } else if result > 0.5 && result <= 0.8 {
            face = "FaceNormal"
        } else {
            face = "FaceGood"
        }
        
        return face
    }
    
    var body: some View {
        ZStack {
            
            // MARK: ProgressBar baseLine
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.72, height: 8)
                .foregroundColor(.gray5)
            
            // MARK: 진행도에 따라 Progressbar 길이 조절
            HStack {
                Rectangle()
                    .frame(width: coreDataStore.returnWidth(width: CGFloat(myWordNote.repeatCount)),
                           height: 8)
                    .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    .padding(.leading, 25)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                
                // MARK: 1회차
                Circle()
                    .frame(width: backgroundCircleSize,
                           height: backgroundCircleSize)
                    .foregroundColor(myWordNote.repeatCount <= 0
                                     ? .gray5
                                     : coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    .overlay {
                        Text("1")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .overlay {
                        if myWordNote.repeatCount > 0 {
                            ZStack {
                                Circle()
                                    .frame(width: backgroundCircleSize,
                                           height: backgroundCircleSize)
                                    .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                                // FIXME: DB수정 후 결과에 따라 표정 변하도록 수정
                                Image("\(returnTestResultFace(result: myWordNote.firstTestResult))")
                                    .resizable()
                                    .frame(width: numberCircleSize,
                                           height: numberCircleSize)
                            }
                        }
                    }
                
                Spacer()
                
                // MARK: 2회차
                Circle()
                    .frame(width: backgroundCircleSize,
                           height: backgroundCircleSize)
                    .foregroundColor(myWordNote.repeatCount <= 1
                                     ? .gray5
                                     : coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    .overlay {
                        Text("2")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .overlay {
                        if myWordNote.repeatCount > 1 {
                            ZStack {
                                Circle()
                                    .frame(width: backgroundCircleSize,
                                           height: backgroundCircleSize)
                                    .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                                Image("CheckMark")
                                    .resizable()
                                    .frame(width: numberCircleSize,
                                           height: numberCircleSize)
                            }
                        }
                    }
                
                Spacer()
                
                // MARK: 3회차
                Circle()
                    .frame(width: backgroundCircleSize,
                           height: backgroundCircleSize)
                    .foregroundColor(myWordNote.repeatCount <= 2
                                     ? .gray5
                                     : coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    .overlay {
                        Text("3")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .overlay {
                        if myWordNote.repeatCount > 2 {
                            ZStack {
                                Circle()
                                    .frame(width: backgroundCircleSize,
                                           height: backgroundCircleSize)
                                    .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                                Image("CheckMark")
                                    .resizable()
                                    .frame(width: numberCircleSize,
                                           height: numberCircleSize)
                            }
                        }
                    }
                
                Spacer()
                
                // MARK: 4회차
                Circle()
                    .frame(width: backgroundCircleSize,
                           height: backgroundCircleSize)
                    .foregroundColor(myWordNote.repeatCount <= 3
                                     ? .gray5
                                     : coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                    .overlay {
                        Text("4")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .overlay {
                        if myWordNote.repeatCount > 3 {
                            ZStack {
                                Circle()
                                    .frame(width: backgroundCircleSize,
                                           height: backgroundCircleSize)
                                    .foregroundColor(coreDataStore.returnColor(category: myWordNote.noteCategory ?? ""))
                                // FIXME: DB수정 후 결과에 따라 표정 변하도록 수정
                                Image("\(returnTestResultFace(result: myWordNote.lastTestResult))")
                                    .resizable()
                                    .frame(width: numberCircleSize,
                                           height: numberCircleSize)
                            }
                        }
                    }
            }
            .frame(width: UIScreen.main.bounds.width * 0.74)
        }
    }
}

struct FaceProgressView_Previews: PreviewProvider {
    static var previews: some View {
        FaceProgressView(myWordNote: NoteEntity()
        )
    }
}
