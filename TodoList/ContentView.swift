//
//  ContentView.swift
//  TodoList
//
//  Created by 安路与 on 2025/5/10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTodoTitle = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("新任务", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newTodoTitle.isEmpty {
                            viewModel.addTodo(title: newTodoTitle)
                            newTodoTitle = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                Picker("过滤", selection: $viewModel.currentFilter) {
                    Text("全部").tag(TodoViewModel.FilterOption.all)
                    Text("已完成").tag(TodoViewModel.FilterOption.completed)
                    Text("未完成").tag(TodoViewModel.FilterOption.incomplete)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.filteredTodos) { todo in
                        HStack {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleTodoCompletion(todo: todo)
                                }
                            
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                }
            }
            .navigationTitle("待办事项")
            .alert("错误", isPresented: $showingError) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
