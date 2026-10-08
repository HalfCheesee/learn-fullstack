import type { Todo, TodoCreate, TodoUpdate } from './types'

const BASE = '/api/todos'

async function handle<T>(res: Response): Promise<T> {
    if (!res.ok) {
        const text = await res.text()
        throw new Error(`HTTP ${res.status} - ${text}`)
    }
    if (res.status === 204) return undefined as T
    return (await res.json()) as T
}

export const api = {
    list: () => fetch(BASE).then((r) => handle<Todo[]>(r)),

    create: (data: TodoCreate) =>
        fetch(BASE, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json'},
            body: JSON.stringify(data),
        }).then((r) => handle<Todo>(r)),

    update: (id: number, data: TodoUpdate) =>
        fetch(`${BASE}/${id}`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        }).then((r) => handle<Todo>(r)),

    remove: (id: number) =>
        fetch(`${BASE}/${id}`, { method: 'DELETE'}).then((r) => handle<void>(r)),
}