# 班级管理系统

中职班级综合管理 Web 系统（Flask + SQLite），适用于班主任日常管理。多用户独立数据库，本地存储，无需联网，支持飞牛 NAS 部署。

**版本**: v1.0.36  
**作者**: 万钟（榆中县职业技术学校）  
**源码**: https://github.com/Jwzhonga/class-manager  
**Release**: https://github.com/Jwzhonga/class-manager/releases/tag/v1.0.36  

---

## 快速启动

```bash
git clone https://github.com/Jwzhonga/class-manager.git
cd class-manager
pip install -r requirements.txt
python3 app.py
# 访问 http://localhost:5800  默认账号: admin / admin123
```

---

## 功能模块

| 模块 | 路由 | 说明 |
|------|------|------|
| 仪表盘 | `/` | 统计卡片、到期预警 |
| 学生管理 | `/students` | 14列完整信息、批量操作、流失管理、快捷编辑、导入导出 |
| 每日考勤 | `/attendance` | 11课时位掩码、状态颜色（出勤🟢/事假🟡/病假🔵/旷课🔴）、图片凭证 |
| 考勤周视图 | `/attendance/weekly` | 周导航、学生出勤概览 |
| 考勤统计 | `/attendance/stats` | 出勤率、病事假统计图表 |
| 成绩管理 | `/grades` | 按科目4项评分、分析图表 |
| 任课管理 | `/teaching` | 跨班级科目管理、独立学生导入/删除 |
| 实训管理 | `/training` | 自定义项目、按人/分组录入 |
| 实训分组 | `/training/groups` | 分组管理、未分配学生自动过滤 |
| 班级课表 | `/schedule` | 多sheet、颜色填充、拖拽调整、高亮 |
| 座位管理 | `/seat` | 座位网格、拖拽换座、自动排座 |
| 处分管理 | `/discipline` | 多图上传、到期预警（30天）、导出 |
| 违纪记录 | `/violation` | 1-15天反省、到期提醒 |
| 班费管理 | `/fund` | 收支记录、凭证、XLSX导出 |
| 数据管理 | `/data` | 全量导出、加密备份（.cmb）、版本化恢复 |
| 学期管理 | 侧边栏 | 模板新建、重命名、删除（数据严格隔离） |

---

## 数据安全

- **本地存储**: 所有数据存本地 SQLite，不依赖外部服务
- **多用户隔离**: 每用户独立数据库 `instance/users/u{id}.db`
- **加密备份**: `.cmb` 格式 + Fernet 加密，仅当前用户可解密恢复
- **前向兼容**: 备份文件记录 schema 版本，恢复时自动迁移补全缺失列
- **学期隔离**: 不同学期数据完全分离

---

## 飞牛 NAS 部署

支持 `.fpk` 格式安装。从 [Releases](https://github.com/Jwzhonga/class-manager/releases) 下载 `Classmanager.fpk`，在飞牛应用中心手动安装。

- 安装时自动安装 Python 依赖（清华镜像）
- 数据库持久化到 `TRIM_PKGVAR`，升级不丢数据
- 端口：5800

---

## 技术栈

| 层 | 技术 | 说明 |
|----|------|------|
| 后端 | Python 3 + Flask + Flask-SQLAlchemy | Web 框架 + ORM |
| 数据库 | SQLite | 本地文件存储 |
| 前端 | Bootstrap 5 + FontAwesome 6 | 响应式 UI + 图标 |
| 导出 | openpyxl | XLSX 导出 |
| 加密 | cryptography.fernet | 备份加密 |
| 服务器 | waitress | 生产级 WSGI（macOS 部署） |
| NAS 打包 | fnpack | fpk 格式构建 |
