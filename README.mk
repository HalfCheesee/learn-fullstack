一 
先建立Git仓库
用于存储整个项目



二
用 Docker 设置数据库

用一份配置文件描述  我要一个 PostgreSQL  
Dockers 会自动跑起来
docker-compose.yml 就是那段描述
我们要写两个服务
1、 db = 数据库本身
2、 adminer = 一个网页版的数据库管理姐面   用浏览器看数据


三
使用 .venv 创建虚拟环境

.venv 是一个隐藏文件夹，里面存放了虚拟环境的所有依赖包
.venv 与 conda的区别
conda 是跨平台管理工具  启动依赖多   适用于数据科学项目
.venv 是python自带的虚拟环境工具  启动依赖少   适用于纯python项目

创建 requirements.txt 文件
并用 pip install -r requirements.txt 配置开发环境


四
写后端代码  prefix = backend/

1  .env
存数据库连接信息  CORS白名单   不放进Git (有密码之类的信息)

2  app/__init__.py
将 app 初始化为 python软件包  可以通过 from app import ... 导入其中内容

3  app/config.py
真正配置后端  读取.env  将配置变成一个 python 对象

4  app/db.py
管理数据库连接  包括
	1  一个engine  负责与PostgreSQL建立连接池
	2	一个SessionLocal  负责给每个请求发一个会话
	3  Base类  所有数据库表模型都继承它
	4  get_db 依赖函数  FastAPI用它给每个请求分配session

5  app/models.py
定义数据库结构

6  app/schemas.py
定义  接口的输入/输出  结构
使用Pydantic进行检验
为什么不直接用 models 中的 Todo
因为数据库对象和 API 数据经常不完全一样
比如 id 是数据库自动生成的  API中不传入  created_at 也是自动生成的  不需要传入
所以分开定义

7  app/crud.py
数据库操作函数  增删改查  Create / Read / Update / Delete
取出在 models 中定义的 Todo 数据库结构
按照 schemas 中的接口形式  将 Todo 结构放入数据库中 

8  app/api.py
定义 HTTP 接口 即路由

9  app/main.py
整个后端的入口
创建FastAPI应用  挂路由  配CORS  管理生命周期

五
用 Alembic 建表 + 测接口
当前写了一个 Todo 类  但是数据库中还没有 todos 表
Python类只是图纸  需要有人按照Python图纸搭建所设计的数据库
Alembic是数据库的版本管理工具  也就是数据库的 Git

核心流程

改 Python 模型 (models.py)
      ↓
alembic revision --autogenerate -m "说明"
      ↓  生成一个迁移脚本文件（里面是 SQL 操作的 Python 版）
alembic upgrade head
      ↓  执行这个脚本  真的改数据库
数据库表结构更新了 ✅

现在已经实现
1  通过python定义数据库结构
2  使用通过函数映射为SQL语句
3  创建并连接数据库
4  使用接口操作数据库

六  前端   prefix = frontend/src/
React  前端UI
TypeScript  检查代码  实时报错
Vite  开发服务器 + 打包工具
Hooks  React的组件函数  用 useState 存状态  user Effect 处理 进入页面时拉取数据

1  用 Vite 生成 React + TS 模板

2  types.ts 类型定义  
   定义前端看到的 Todo 结构 

3  api.ts  前端与后端交互的函数
   将所有的 fetch 调用封装为函数  其他地方不写 fetch

4  hooks\useTodos.ts
   作用 把数据从哪来 怎么增删改查  出错怎么办  加载中怎么显示  这些逻辑集中在一个 hook 中
   这是最重要的一个文件  也是学 useState useEffect useCallback 的核心

5  components\TodoForm.tsx  输入表单
   作用 一个输入框 + 一个提交按钮

6  components\TodoList.tsx  前端列表
   展示任务列表 每一项带勾选框和删除按钮

7  App.tsx  页面入口
   作用 组合 TodoForm 和 TodoList 两个组件

8  main.tsx  React应用入口
   作用 让 React 应用跑起来




1 恢复 Docker
打开 Docker 后
docker compose up -d
docker compose ps
2 恢复后端 激活 .venv
uvicorn app.main:app --reload --port 8000