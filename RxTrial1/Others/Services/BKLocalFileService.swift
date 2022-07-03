//
// Created by Ben KIM on 2022/07/02.
//

import Foundation

///로컬에 파일 저장하는 것 담당 서비스
protocol BKLocalFileServiceProtocol {
    /// Type 별 로컬 저장 Directory 경로
    func directory(with type: BKFileType) -> URL?

    /// 저장하고 저장한 경로 반환
    func saveFile(type: BKFileType, data: Data, name: String) -> URL?

    /// 파일 type 별 저장한 전체 경로
    func filePath(type: BKFileType, name: String) -> URL?
}

enum BKFileType: String {
    case mp3
    case cover
}

class BKLocalFileService: BKLocalFileServiceProtocol {
    func directory(with type: BKFileType) -> URL? {
        documentSubDirecory(type.rawValue)
    }

    func saveFile(type: BKFileType, data: Data, name: String) -> URL? {
        let fileManager = FileManager.default
        guard let filePath = filePath(type: type, name: name) else {
            return nil
        }
        if fileManager.fileExists(atPath: filePath.path) {
            try? fileManager.removeItem(atPath: filePath.path)
        }
        fileManager.createFile(atPath: filePath.path, contents: data)
        return filePath
    }

    private func documentSubDirecory(_ path: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directory = documentDirectory.appendingPathComponent(path)
        if !fileManager.fileExists(atPath: directory.path) {
            do {
                try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                print(error)
                return nil
            }
        }

        return directory
    }

    func filePath(type: BKFileType, name: String) -> URL? {
        guard let directory = directory(with: type) else {
            return nil
        }
        return directory.appendingPathComponent(name)
    }
}
