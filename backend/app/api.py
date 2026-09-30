from webbrowser import get

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app import crud
from app.db import get_db
from app.schemas import TodoCreate, TodoRead, TodoUpdate

router = APIRouter(prefix="/api/todos", tags=["todos"])


@router.get("", response_model=list[TodoRead])
async def list_todos(db: AsyncSession = Depends(get_db)):
    return await crud.list_todos(db)


@router.post("", response_model=TodoRead, status_code=status.HTTP_201_CREATED)
async def create_todo(payload: TodoCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_todo(db, payload)


@router.patch("/{todo_id}", response_model=TodoRead)
async def update_todo(
    todo_id: int,
    payload: TodoUpdate,
    db: AsyncSession = Depends(get_db),
):
    todo = await crud.get_todo(db, todo_id)
    if todo is None:
        raise HTTPException(404, "Todo not found")
    return await crud.update_todo(db, todo, payload)


@router.delete("/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_todo(todo_id: int, db: AsyncSession = Depends(get_db)):
    todo = await crud.get_todo(db, todo_id)
    if todo is None:
        raise HTTPException(404, "Todo not found")
    await crud.delete_todo(db, todo)
