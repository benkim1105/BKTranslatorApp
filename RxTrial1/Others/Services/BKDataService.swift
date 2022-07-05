//
//  BKDataService.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/02.
//

import Foundation
import RxSwift
import UIKit
import CoreData

enum DataServiceError: Error {
    case invalidType
    case internalError
}

enum DataElementType: String {
    case Episode
    case Sentence
}

struct ListResult<E: Codable> {
    let items: [E]
    let nextStartToken: String?
}

enum OrderDirection {
    case asc
    case desc
    
    var value: Bool {
        self == .asc
    }
}

///사용자가 생산한 데이터를 입출력하는 서비스
protocol BKDataServiceProtocol {
    typealias ServerId = String
    
    ///Element 하나를 서버에 저장한다.
    func save<E>(_ element: E, type: DataElementType) -> Observable<ServerId> where E: Codable
    
    ///Element 목록을 서버에 저장한다.
    func saveList<E>(_ list: [E], type: DataElementType) -> Observable<[ServerId]> where E: Codable
    
    ///Element 하나를 서버에서 가져온다.
    func getElement<E>(type: DataElementType, id: String) -> Observable<E?> where E: Codable
    
    ///Element 목록을 서버에서 가져온다.
    func getList<E>(type: DataElementType, startToken: String?, count: Int?, order: [(String, OrderDirection)]?) -> Observable<ListResult<E>> where E: Codable
}

///서버가 없으니 일단 그냥 CoreData 로 구현. 나중에 리모트로 변환
class BKLocalDataService: BKDataServiceProtocol {
    private var context: NSManagedObjectContext
    
    init (managedObjectContext: NSManagedObjectContext) {
        self.context = managedObjectContext
    }
    
    func save<E>(_ element: E, type: DataElementType) -> Observable<ServerId> where E: Codable {
        guard let mapper = ElementMapper(type: type) else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: mapper.coreDataEntityName,
            in: context)
        else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        let id = mapper.setValue(fromElement: element, toObject: object)
        
        do {
            try context.save()
        } catch {
            return Observable.error(DataServiceError.internalError)
        }
        
        return Observable.just(id)
    }
    
    func saveList<E>(_ list: [E], type: DataElementType) -> Observable<[ServerId]> where E: Codable {
        guard let mapper = ElementMapper(type: type) else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        guard let entity = NSEntityDescription.entity(
            forEntityName: mapper.coreDataEntityName,
            in: context)
        else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        var serverIds: [ServerId] = []
        for item in list {
            let object = NSManagedObject(entity: entity, insertInto: context)
            let serverId = mapper.setValue(fromElement: item, toObject: object)
            serverIds.append(serverId)
        }
        
        do {
            try context.save()
        } catch {
            return Observable.error(error)
        }
        
        return Observable.just(serverIds)
    }
    
    func getElement<E>(type: DataElementType, id: String) -> Observable<E?> where E: Codable {
        guard let mapper = ElementMapper(type: type) else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: mapper.coreDataEntityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(request)
            guard let object = result.first else {
                return Observable.just(nil)
            }
            
            let element = mapper.getElement(from: object as! NSManagedObject) as! E
            return Observable.just(element)
        } catch {
            return Observable.error(error)
        }
    }
    
    func getList<E>(type: DataElementType, startToken: String?, count: Int?, order: [(String, OrderDirection)]? = nil) -> Observable<ListResult<E>> where E : Codable {

        guard let mapper = ElementMapper(type: type) else {
            return Observable.error(DataServiceError.invalidType)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: mapper.coreDataEntityName)
        if let startToken = startToken {
            request.fetchOffset = Int(startToken) ?? 0
        }
        if let count = count {
            request.fetchLimit = count
        }
        if let order = order {
            let sortDescriptors = order.map { NSSortDescriptor(key: $0.0, ascending: $0.1.value) }
            request.sortDescriptors = sortDescriptors
        }

        do {
            let results = try context.fetch(request)
            
            var elements: [E] = []
            for result in results {
                let element = mapper.getElement(from: result as! NSManagedObject) as! E
                elements.append(element)
            }
            
            var nextStartToken: String? = nil
            if let count = count, elements.count == count {
                nextStartToken = String(request.fetchOffset + elements.count)
            }
            let listResult = ListResult(items: elements, nextStartToken: nextStartToken)
            return Observable.just(listResult)
        } catch {
            return Observable.error(error)
        }
    }
}

/// ViewModel 에서 쓰는 모델과 Persistent 계층의 모델 매핑
private enum ElementMapper: String {
    case Episode
    case Sentence
    
    typealias ServerId = String
    
    init?(type: DataElementType) {
        self.init(rawValue: type.rawValue)
    }
    
    var coreDataEntityName: String {
        return self.rawValue
    }
    
    func setValue(fromElement: Any, toObject: NSManagedObject) -> ServerId {
        switch self {
        case .Episode:
            return map(episode: fromElement as! BKEpisode, toObject: toObject as! Episode)
        case .Sentence:
            return map(sentence: fromElement as! BKSentence, toObject: toObject as! Sentence)
        }
    }
    
    func getElement(from object: NSManagedObject) -> Any {
        switch self {
        case .Episode:
            return BKEpisode(episode: object as! Episode)
        case .Sentence:
            return BKSentence(sentence: object as! Sentence)
        }
    }
    
    private func map(episode: BKEpisode, toObject: Episode) -> ServerId {
        let fakeServerId = UUID().uuidString
        toObject.id = episode.id
        toObject.title = episode.title
        toObject.image = episode.image
        toObject.serverId = fakeServerId
        toObject.timestamp = Date()
        return fakeServerId
    }
    
    private func map(sentence: BKSentence, toObject: Sentence) -> ServerId {
        let fakeServerId = UUID().uuidString
        toObject.id = sentence.id
        toObject.bookId = sentence.bookId
        toObject.sentence = sentence.sentence
        toObject.translation = sentence.translation
        toObject.sentenceLanguage = sentence.sentenceLanguage.rawValue
        toObject.translationLanguage = sentence.translationLanguage.rawValue
        toObject.serverId = fakeServerId
        toObject.timestamp = Date()
        return fakeServerId
    }
}

extension BKEpisode {
    init(episode: Episode) {
        self.id = episode.id ?? "0"
        self.serverId = episode.serverId
        self.title = episode.title ?? ""
        self.image = episode.image
        self.timestamp = episode.timestamp
    }
}

extension BKSentence {
    init(sentence: Sentence) {
        self.id = sentence.id
        self.bookId = sentence.bookId
        self.sentence = sentence.sentence ?? ""
        self.translation = sentence.translation ?? ""
        self.sentenceLanguage = Language(rawValue: sentence.sentenceLanguage ?? "") ?? .en
        self.translationLanguage = Language(rawValue: sentence.translationLanguage ?? "") ?? .ko
        self.timestamp = sentence.timestamp
        self.serverId = sentence.serverId
    }
}
