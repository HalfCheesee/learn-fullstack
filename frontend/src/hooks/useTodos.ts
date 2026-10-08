import { useCallback, useEffect, useState } from 'react'
import { api } from '../api'
import type { Todo } from '../types'

export function useTodos() {
    const [todos, setTodos] = useState<Todo[]>([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)

    const refresh = useCallback(async () => {
        setLoading(true)
        setError(null)
        try {
            setTodos(await api.list())
        } catch (e) {
            setError(e instanceof Error ? e.message : String(e))
        } finally {
            setLoading(false)
        }
    }, [])

    useEffect(() => {
        refresh()
    }, [refresh])

    const add = async (title: string) => {
        await api.create({title})
        await refresh()
    }

    const toggle = async (todo: Todo) => {
        await api.update(todo.id, {done: !todo.done})
        await refresh()
    }

    const remove = async (id: number) => {
        await api.remove(id)
        await refresh()
    }

    return { todos, loading, error, add, toggle, remove, refresh }
}

