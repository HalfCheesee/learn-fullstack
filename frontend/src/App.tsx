import { TodoForm } from './components/TodoForm'
import { TodoList } from './components/TodoList'
import { useTodos } from './hooks/useTodos'

export default function App() {
  const { todos, loading, error, add, toggle, remove } = useTodos()

  return (
    <div
      style={{
        maxWidth: 480,
        margin: '40px auto',
        fontFamily: 'system-ui, sans-serif',
      }}
    >
      <h1>Todo · 全栈学习</h1>
      <TodoForm onAdd={add} />
      {loading && <p>加载中…</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <TodoList todos={todos} onToggle={toggle} onRemove={remove} />
    </div>
  )
}