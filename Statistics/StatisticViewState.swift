import Foundation

enum StatisticsViewState: Equatable {
    case loading
    case content
    case empty
    case error(String)
}
