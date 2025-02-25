import Foundation

enum FileError: Error {
    case fileNotFound, invalidFormat, accessDenied
}
