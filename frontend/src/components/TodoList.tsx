import type { Todo } from '../types'

interface Props {
  todos: Todo[]
  onToggle: (t: Todo) => void
  onRemove: (id: number) => void
}

export function TodoList({ todos, onToggle, onRemove }: Props) {
  if (todos.length === 0) return <p style={{ opacity: 0.6 }}>暂无任务</p>

  return (
    <ul style={{ listStyle: 'none', padding: 0 }}>
      {todos.map((todo) => (
        <li
          key={todo.id}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: 8,
            padding: '8px 0',
            borderBottom: '1px solid #eee',
          }}
        >
          <input
            type="checkbox"
            checked={todo.done}
            onChange={() => onToggle(todo)}
          />
          <span
            style={{
              flex: 1,
              textDecoration: todo.done ? 'line-through' : 'none',
              opacity: todo.done ? 0.6 : 1,
            }}
          >
            {todo.title}
          </span>
          <button onClick={() => onRemove(todo.id)}>删除</button>
        </li>
      ))}
    </ul>
  )
}