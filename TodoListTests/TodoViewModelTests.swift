import XCTest
@testable import TodoList

final class TodoViewModelTests: XCTestCase {
    var viewModel: TodoViewModel!
    var mockService: MockTodoService!
    
    override func setUp() {
        super.setUp()
        mockService = MockTodoService()
        viewModel = TodoViewModel(todoService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testAddTodo() {
        // Given
        let title = "测试待办事项"
        
        // When
        viewModel.addTodo(title: title)
        
        // Then
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos[0].title, title)
        XCTAssertFalse(viewModel.todos[0].isCompleted)
    }
    
    func testDeleteTodo() {
        // Given
        viewModel.addTodo(title: "待删除项目")
        XCTAssertEqual(viewModel.todos.count, 1)
        
        // When
        viewModel.deleteTodo(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(viewModel.todos.count, 0)
    }
    
    func testToggleTodoCompletion() {
        // Given
        viewModel.addTodo(title: "待切换项目")
        let todo = viewModel.todos[0]
        XCTAssertFalse(todo.isCompleted)
        
        // When
        viewModel.toggleTodoCompletion(todo: todo)
        
        // Then
        XCTAssertTrue(viewModel.todos[0].isCompleted)
    }
    
    func testLoadTodos() {
        // Given
        let mockTodos = [
            Todo(title: "测试项目1"),
            Todo(title: "测试项目2")
        ]
        mockService.mockTodos = mockTodos
        
        // When
        viewModel = TodoViewModel(todoService: mockService)
        
        // Then
        XCTAssertEqual(viewModel.todos.count, 2)
        XCTAssertEqual(viewModel.todos[0].title, "测试项目1")
        XCTAssertEqual(viewModel.todos[1].title, "测试项目2")
    }
    
    // MARK: - 过滤功能测试
    
    func testFilterAll() {
        // Given
        viewModel.addTodo(title: "已完成项目")
        viewModel.addTodo(title: "未完成项目")
        viewModel.toggleTodoCompletion(todo: viewModel.todos[0])
        
        // When
        viewModel.currentFilter = .all
        
        // Then
        XCTAssertEqual(viewModel.filteredTodos.count, 2)
    }
    
    func testFilterCompleted() {
        // Given
        viewModel.addTodo(title: "已完成项目")
        viewModel.addTodo(title: "未完成项目")
        viewModel.toggleTodoCompletion(todo: viewModel.todos[0])
        
        // When
        viewModel.currentFilter = .completed
        
        // Then
        XCTAssertEqual(viewModel.filteredTodos.count, 1)
        XCTAssertEqual(viewModel.filteredTodos[0].title, "已完成项目")
    }
    
    func testFilterIncomplete() {
        // Given
        viewModel.addTodo(title: "已完成项目")
        viewModel.addTodo(title: "未完成项目")
        viewModel.toggleTodoCompletion(todo: viewModel.todos[0])
        
        // When
        viewModel.currentFilter = .incomplete
        
        // Then
        XCTAssertEqual(viewModel.filteredTodos.count, 1)
        XCTAssertEqual(viewModel.filteredTodos[0].title, "未完成项目")
    }
}

// MARK: - Mock Service
class MockTodoService: TodoServiceProtocol {
    var mockTodos: [Todo] = []
    
    func saveTodos(_ todos: [Todo]) {
        mockTodos = todos
    }
    
    func loadTodos() -> [Todo] {
        return mockTodos
    }
} 