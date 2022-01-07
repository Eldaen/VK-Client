//
//  AsyncOperation.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation

/// Базовый класс для асинхронных операций
class AsyncOperation: Operation {
	
	/// Перечисление состояний операции
	enum State: String {
		case ready
		case executing
		case finished
		
		var keyPath: String {
			return "is" + rawValue.capitalized
		}
	}
	
	/// Текущее состояние операции
	var state = State.ready {
		willSet {
			willChangeValue(forKey: state.keyPath)
			willChangeValue(forKey: newValue.keyPath)
		}
		
		didSet {
			didChangeValue(forKey: state.keyPath)
			didChangeValue(forKey: oldValue.keyPath)
		}
	}
	
	///  Флаг режима выполнения задачи, асинхронно или нет
	override var isAsynchronous: Bool {
		return true
	}
	
	/// Флаг состояния isReady
	override var isReady: Bool {
		return super.isReady && state == .ready
	}
	
	/// Флаг состояния isExecuting
	override var isExecuting: Bool {
		return state == .executing
	}
	
	/// Флаг состояния isFinished
	override var isFinished: Bool {
		return state == .finished
	}
	
	/// Запускает выполнение операции
	override func start() {
		if isCancelled {
			state = .finished
		} else {
			main()
			state = .executing
		}
	}
	
	/// Ставит флаг отмены выполнения задачи
	override func cancel() {
		super.cancel()
		state = .finished
	}
	
}
