//
//  MyWordNote.swift
//  Memorizing
//
//  Created by 이종현 on 2023/01/18.
//

import Foundation
import SwiftUI

// MARK: WordNote - 암기장
struct MyWordNote: Identifiable, NoteProtocol {
    var id: String
    var noteName: String
    var noteCategory: String
    var enrollmentUser: String
    var repeatCount: Int
    var firstTestResult: Double
    var lastTestResult: Double
    var updateDate: Date
    var nextStudyDate: Date?
    
    // MARK: 마켓 거래내역 관련 추가 - 현기
    /// 마켓에서 구매한 날짜
    var marketPurchaseDate: Date?
    /// 마켓에서 구매한 가격
    var notePrice: Int?
    /// 리뷰 작성 시간
    var reviewDate: Date? 
    
    // 카테고리와 색상 매칭
    var noteColor: Color {
        switch noteCategory {
        case "영어":
            return Color.englishColor
        case "한국사":
            return Color.historyColor
        case "IT":
            return Color.iTColor
        case "경제":
            return Color.economyColor
        case "시사":
            return Color.knowledgeColor
        case "기타":
            return Color.etcColor
        default:
            return Color.mainDarkBlue
        }
    }
    
    // 학습 횟수에 따른 프로그래스바 길이 매칭
    var progressbarWitdh: Double {
        switch repeatCount {
        case 0, 1:
            return 0.0
        case 2:
            return 97.0
        case 3:
            return 185.0
        default:
            return 260.0
        }
    }
    
    /// marketPurchaseDate 날짜 형식 변경
    var marketPurchaseDateFormatter: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: marketPurchaseDate ?? Date())
    }
    
}
