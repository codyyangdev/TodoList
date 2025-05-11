import Foundation

/// 待办事项模型
/// 遵循 Identifiable 协议以支持在 SwiftUI 列表中的唯一标识
/// 遵循 Codable 协议以支持数据的序列化和反序列化
struct Todo: Identifiable, Codable {
    /// 待办事项的唯一标识符
    let id: UUID
    
    /// 待办事项的标题
    var title: String
    
    /// 待办事项的完成状态
    var isCompleted: Bool
    
    /// 待办事项的创建时间
    var createdAt: Date
    
    /// 初始化一个新的待办事项
    /// - Parameters:
    ///   - id: 唯一标识符，默认生成新的 UUID
    ///   - title: 待办事项标题
    ///   - isCompleted: 完成状态，默认为 false
    ///   - createdAt: 创建时间，默认为当前时间
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
} 