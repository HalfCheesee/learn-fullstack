import { useState, type SubmitEvent } from 'react'

interface Props {
    onAdd: (title: string) => Promise<void>
}

export function TodoForm({ onAdd }: Props) {
    const [title, setTitle] = useState('')
    const [submitting, setSubmitting] = useState(false)


    const handleSubmit = async (e: SubmitEvent) => {
        e.preventDefault()
        const trimmed = title.trim()
        if (!trimmed) return
        setSubmitting(true)
        try {
            await onAdd(trimmed)
            setTitle('')
        }finally {
            setSubmitting(false)
        }
    }


    return (
        <form onSubmit={handleSubmit} style={{ display: 'flex', gap: 8 }}>
            <input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="What needs to be done?"
                disabled={submitting}
                style={{ flex: 1, padding: 8 }}
            />
            <button type="submit" disabled={submitting || !title.trim()}>
                {submitting ? 'Adding...' : 'Add'}
            </button>
        </form>
    )
}
