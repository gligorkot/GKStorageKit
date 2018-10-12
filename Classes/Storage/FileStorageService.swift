//
//  FileStorageService.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import GKBaseKit

final class FileStorageService: FileStorageInterface {

    private var documentsUrl: URL

    init(documentsUrl: URL) {
        self.documentsUrl = documentsUrl
    }

    func storeFile(_ fileData: Data, fileExtension: String, onSuccess: @escaping (URL) -> (), onFail: @escaping FailureBlock) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileName = UUID().uuidString
            let destinationUrl = self.documentsUrl.appendingPathComponent("\(fileName).\(fileExtension)")

            if let _ = try? fileData.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                onSuccess(destinationUrl)
            } else {
                // unable to write to file error here
                let error = StorageError.saveFileError
                onFail(error.toResponse())
            }
        }
    }
    
    func cleanStorage(onSuccess: @escaping () -> (), onFail: @escaping FailureBlock) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let filePaths = try FileManager.default.contentsOfDirectory(at: self.documentsUrl, includingPropertiesForKeys: nil, options: [])
                for filePath in filePaths {
                    try FileManager.default.removeItem(at: filePath)
                }
                onSuccess()
            } catch {
                // unable to clear documents directory
                let error = StorageError.cleanFileStorageError
                onFail(error.toResponse())
            }
        }
    }


}
