export interface Todo {
    id: number
    title: string
    done: boolean
    created_at: string
}

export interface TodoCreate {
    title: string
}

export interface TodoUpdate {
    title?: string
    done?: boolean
}