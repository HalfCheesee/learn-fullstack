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


