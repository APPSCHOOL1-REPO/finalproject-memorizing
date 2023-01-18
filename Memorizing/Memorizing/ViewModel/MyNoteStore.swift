//
//  MyNoteStore.swift
//  Memorizing
//
//  Created by 진준호 on 2023/01/18.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyNoteStore: ObservableObject {
    @Published var myWordNotes: [MyWordNote] = []
    @Published var myWords: [Word] = []
    
    let database = Firestore.firestore()

    // MARK: - myWordNotes를 페치하는 함수 / 내가 작성한 Notes를 Fetch함
    func myNotesWillBeFetchedFromDB() {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        database.collection("users").document(currentUser.uid).collection("myWordNotes")
            .order(by: "repeatCount")
            .getDocuments { snapshot, error in
            self.myWordNotes.removeAll()
            if let snapshot {
                for document in snapshot.documents {
                    let docData = document.data()
                    let id: String = docData["id"] as? String ?? ""
                    let noteName: String = docData["noteName"] as? String ?? ""
                    let noteCategory: String = docData["noteCategory"] as? String ?? ""
                    let enrollmentUser: String = docData["enrollmentUser"] as? String ?? ""
                    let repeatCount: Int = docData["repeatCount"] as? Int ?? 0
                    let firstTestResult: Double = docData["firstTestResult"] as? Double ?? 0
                    let lastTestResult: Double = docData["lastTestResult"] as? Double ?? 0
                    let createdAtTimeStamp: Timestamp = docData["updateDate"] as? Timestamp ?? Timestamp()
                    let updateDate: Date = createdAtTimeStamp.dateValue()
                    let myWordNote = MyWordNote(id: id,
                                                noteName: noteName,
                                                noteCategory: noteCategory,
                                                enrollmentUser: enrollmentUser,
                                                repeatCount: repeatCount,
                                                firstTestResult: firstTestResult,
                                                lastTestResult: lastTestResult,
                                                updateDate: updateDate)
                    self.myWordNotes.append(myWordNote)
                }
            }
        }
    }
    
    // MARK: - myWordNotes를 추가하는 함수 / 내가 작성한 Notes를 DB에 저장함
    func myNotesWillBeSavedOnDB(wordNote: MyWordNote) {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        database.collection("users").document(currentUser.uid).collection("myWordNotes").document(wordNote.id)
            .setData([
                "id": wordNote.id,
                "noteName": wordNote.noteName,
                "noteCategory": wordNote.noteCategory,
                "enrollmentUser": wordNote.enrollmentUser,
                "repeatCount": wordNote.repeatCount,
                "updateDate": wordNote.updateDate
            ]) { err in
                
            }
        myNotesWillBeFetchedFromDB()
    }
    
    // MARK: - words를 패치하는 함수 / 내가 작성한 Words를 Fetch함
    func myWordsWillBeFetchedFromDB(wordNote: MyWordNote, completion: @escaping () -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        database.collection("users").document(currentUser.uid)
            .collection("myWordNotes").document(wordNote.id)
            .collection("words")
            .order(by: "wordLevel")
            .getDocuments { snapshot, error in
                self.myWords.removeAll()
                if let snapshot {
                    for document in snapshot.documents {
                        let docData = document.data()
                        let id: String = docData["id"] as? String ?? ""
                        let wordString: String = docData["wordString"] as? String ?? ""
                        let wordMeaning: String = docData["wordMeaning"] as? String ?? ""
                        let wordLevel: Int = docData["wordLevel"] as? Int ?? 0
                        
                        let word = Word(id: id, wordString: wordString, wordMeaning: wordMeaning, wordLevel: wordLevel)
                        
                        self.myWords.append(word)
                    }
                }
                completion()
            }
    }
    
    // MARK: - words를 추가하는 함수 / 내가 작성한 Words를 DB에 저장함
    func myWordsWillBeSavedOnDB(wordNote: MyWordNote, word: Word) {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        database.collection("users").document(currentUser.uid)
            .collection("myWordNotes").document(wordNote.id)
            .collection("words").document(word.id)
            .setData([
                "id": word.id,
                "wordString": word.wordString,
                "wordMeaning": word.wordMeaning,
                "wordLevel": word.wordLevel
            ])
    }
    
    // MARK: - 복습 완료시 파베에 repeatCount를 1씩 올림 / 반복학습에 따른 Count를 1씩 증가
    func repeatCountWillBePlusOne(wordNote: WordNote) async {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        do {
            _ = try await database.collection("users").document(currentUser.uid)
                .collection("myWordNotes").document(wordNote.id)
                .updateData([
                    "repeatCount": FieldValue.increment(Int64(1))
                ])
            myNotesWillBeFetchedFromDB()
            print("finish plusRepeatCount")
        } catch {
            fatalError("fail plusRepeat Count")
        }
    }
    
    // MARK: - 복습 다시하기 repeatcount를 0으로 초기화 / 반복학습이 완료될 경우, Count를 Reset
    func repeatCountWillBeResetted(wordNote: WordNote) {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        
        database.collection("users").document(currentUser.uid)
            .collection("myWordNotes").document(wordNote.id)
            .updateData([
                "repeatCount": 0
            ])
        myNotesWillBeFetchedFromDB()
    }
    
    // MARK: - 학습 시 각각 Words의 Level(난이도)값을 DB에 저장
    func wordsLevelWillBeChangedOnDB(wordNote: WordNote, word: Word, level: Int) {
        guard let currentUser = Auth.auth().currentUser else { return print("return no current user")}
        
        database.collection("users").document(currentUser.uid)
            .collection("myWordNotes").document(wordNote.id)
            .collection("words").document(word.id)
            .updateData([
                "wordLevel": level
            ])
        print("updateWordLevel success")
        
    }
}
