import Foundation
import SwiftUI

/// 待办事项视图模型
/// 负责处理待办事项的业务逻辑和数据管理
/// 使用 @Published 属性包装器实现数据绑定
/// 使用 @StateObject 属性包装器实现视图模型实例的声明周期管理
class TodoViewModel: ObservableObject {
    /// 待办事项列表，使用 @Published 属性包装器实现数据绑定
    @Published var todos: [Todo] = []
    
    /// 过滤选项
    enum FilterOption {
        case all
        case completed
        case incomplete
    }
    
    /// 当前过滤选项
    @Published var currentFilter: FilterOption = .all
    
    /// 待办事项服务实例
    private let todoService: TodoServiceProtocol
    
    /// 初始化视图模型
    /// - Parameter todoService: 待办事项服务实例，默认使用 TodoService
    init(todoService: TodoServiceProtocol = TodoService()) {
        self.todoService = todoService
        loadTodos()
    }
    
    /// 从持久化存储加载待办事项
    private func loadTodos() {
        todos = todoService.loadTodos()
    }
    
    /// 添加新的待办事项
    /// - Parameter title: 待办事项标题
    func addTodo(title: String) {
        let newTodo = Todo(title: title)
        todos.append(newTodo)
        saveTodos()
    }
    
    /// 删除指定索引的待办事项
    /// - Parameter indexSet: 要删除的待办事项索引集合
    func deleteTodo(at indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
        saveTodos()
    }
    
    /// 切换待办事项的完成状态
    /// - Parameter todo: 要切换状态的待办事项
    func toggleTodoCompletion(todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    /// 保存待办事项到持久化存储
    private func saveTodos() {
        todoService.saveTodos(todos)
    }
    
    /// 根据当前过滤选项获取过滤后的待办事项列表
    var filteredTodos: [Todo] {
        switch currentFilter {
        case .all:
            return todos
        case .completed:
            return todos.filter { $0.isCompleted }
        case .incomplete:
            return todos.filter { !$0.isCompleted }
        }
    }
} 