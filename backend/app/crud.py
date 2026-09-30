from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import Todo
from app.schemas import TodoCreate, TodoUpdate


async def list_todos(db: AsyncSession) -> list[Todo]:
    result = await db.execute(select(Todo).order_by(Todo.id.desc()))
    return list(result.scalars().all())


async def get_todo(db: AsyncSession, todo_id: int) -> Todo | None:
    return await db.get(Todo, todo_id)


async def create_todo(db: AsyncSession, data: TodoCreate) -> Todo:
    todo = Todo(title=data.title)
    db.add(todo)
    await db.commit()
    await db.refresh(todo)
    return todo


async def update_todo(db: AsyncSession, todo: Todo, data: TodoUpdate) -> Todo:
    for key, value in data.model_dump(exclude_unset=True).items():
        setattr(todo, key, value)

    await db.commit()
    await db.refresh(todo)
    return todo


async def delete_todo(db: AsyncSession, todo: Todo) -> None:
    await db.delete(todo)
    await db.commit()
