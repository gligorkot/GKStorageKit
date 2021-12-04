//
//  StorageError.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import GKBaseKit

enum StorageError: BaseError {

    case saveStringError(String, String)
    case saveObjectError(Codable, String)
    case saveFileError
    case getError(String)
    case deleteError(String)
    case cleanStorageError
    case cleanFileStorageError

    func toResponse() -> ErrorResponse {
        return StorageErrorContentAdapter.adapt(self)
    }

}

private struct StorageErrorResponse: ErrorResponse {

    let title: String
    let message: String
    let debugDescription: String

    init(title: String = "Storage", message: String = "Something went wrong.", debugDescription: String = "") {
        self.title = title
        self.message = message
        self.debugDescription = debugDescription
    }
}

private final class StorageErrorContentAdapter: BaseErrorContentAdapter {
    typealias ErrorType = StorageError

    static func adapt(_ error: StorageError) -> ErrorResponse {
        switch error {
        case .saveStringError,
             .saveObjectError:
            return  StorageErrorResponse(message: "Cannot save secure value. Keychain inaccessible.", debugDescription: "Cannot save secure value. Keychain inaccessible.")
        case .saveFileError:
            return  StorageErrorResponse(message: "Unable to save file to documents directory.", debugDescription: "Unable to save file to documents directory.")
        case .getError:
            return  StorageErrorResponse(message: "Cannot retrieve secure value. Keychain inaccessible.", debugDescription: "Cannot retrieve secure value. Keychain inaccessible.")
        case .deleteError:
            return  StorageErrorResponse(message: "Cannot remove secure value. Keychain inaccessible.", debugDescription: "Cannot remove secure value. Keychain inaccessible.")
        case .cleanStorageError:
            return  StorageErrorResponse(message: "Cannot clean secure storage. Keychain inaccessible.", debugDescription: "Cannot clean secure storage. Keychain inaccessible.")
        case .cleanFileStorageError:
            return  StorageErrorResponse(message: "Unable to clean file storage.", debugDescription: "Unable to clean file storage.")
        }
    }

}

