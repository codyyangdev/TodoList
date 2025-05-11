import Foundation

/// 待办事项服务协议
/// 定义了待办事项数据持久化的基本操作
protocol TodoServiceProtocol {
    /// 保存待办事项列表
    /// - Parameter todos: 要保存的待办事项数组
    func saveTodos(_ todos: [Todo])
    
    /// 加载待办事项列表
    /// - Returns: 已保存的待办事项数组，如果没有保存的数据则返回空数组
    func loadTodos() -> [Todo]
}

/// 待办事项服务实现类
/// 使用 UserDefaults 实现数据的持久化存储
class TodoService: TodoServiceProtocol {
    /// UserDefaults 中存储待办事项的键名
    private let todosKey = "todos"
    
    /// 保存待办事项列表到 UserDefaults
    /// - Parameter todos: 要保存的待办事项数组
    func saveTodos(_ todos: [Todo]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    /// 从 UserDefaults 加载待办事项列表
    /// - Returns: 已保存的待办事项数组，如果解码失败则返回空数组
    func loadTodos() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: todosKey),
              let todos = try? JSONDecoder().decode([Todo].self, from: data) else {
            return []
        }
        return todos
    }
} 