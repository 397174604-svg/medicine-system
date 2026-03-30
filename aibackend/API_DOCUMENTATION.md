# Python Backend API 文档

**基础地址**: `http://localhost:8000`  
**框架**: FastAPI  
**服务**: Uvicorn

---

## 目录

1. [会话管理 API](#1-会话管理-api)
2. [对话 API](#2-对话-api)
3. [文档管理 API](#3-文档管理-api)
4. [数据模型定义](#4-数据模型定义)
5. [错误码](#5-错误码)
6. [使用示例](#6-使用示例)

---

## 1. 会话管理 API

### 1.1 获取会话消息列表

- **URL**: `GET /sessions/{user_id}/{session_id}`
- **描述**: 获取指定会话的所有消息
- **参数**:
  - `user_id` (path): 用户ID
  - `session_id` (path): 会话ID

**响应**: `SessionMessagesResponse`

```json
{
  "messages": [
    {
      "type": "user|assistant",
      "content": "消息内容",
      "timestamp": "2024-01-01T12:00:00",
      "rag_trace": { }
    }
  ]
}
```

---

### 1.2 获取用户会话列表

- **URL**: `GET /sessions/{user_id}`
- **描述**: 获取用户的所有会话列表（按更新时间倒序）
- **参数**:
  - `user_id` (path): 用户ID

**响应**: `SessionListResponse`

```json
{
  "sessions": [
    {
      "session_id": "会话ID",
      "updated_at": "2024-01-01T12:00:00",
      "message_count": 10
    }
  ]
}
```

---

### 1.3 删除会话

- **URL**: `DELETE /sessions/{user_id}/{session_id}`
- **描述**: 删除指定会话
- **参数**:
  - `user_id` (path): 用户ID
  - `session_id` (path): 会话ID

**响应**: `SessionDeleteResponse`

```json
{
  "session_id": "会话ID",
  "message": "成功删除会话"
}
```

---

## 2. 对话 API

### 2.1 普通对话

- **URL**: `POST /chat`
- **描述**: 与 AI Agent 进行对话（非流式）

**请求体**: `ChatRequest`

```json
{
  "message": "用户输入",
  "user_id": "default_user",
  "session_id": "default_session"
}
```

**响应**: `ChatResponse`

```json
{
  "response": "AI回复内容",
  "rag_trace": { }
}
```

---

### 2.2 流式对话

- **URL**: `POST /chat/stream`
- **描述**: 与 AI Agent 进行对话（SSE 流式）

**请求体**: `ChatRequest`

**响应**: `text/event-stream`

```
data: {"type": "content", "content": "..."}

data: {"type": "error", "content": "..."}
```

---

## 3. 文档管理 API

### 3.1 获取文档列表

- **URL**: `GET /documents`
- **描述**: 获取已上传的文档列表

**响应**: `DocumentListResponse`

```json
{
  "documents": [
    {
      "filename": "文档.pdf",
      "file_type": "pdf",
      "chunk_count": 10,
      "uploaded_at": "2024-01-01T12:00:00"
    }
  ]
}
```

---

### 3.2 上传文档

- **URL**: `POST /documents/upload`
- **描述**: 上传文档并进行 Embedding 处理
- **Content-Type**: `multipart/form-data`

**参数**:
- `file` (file): 支持 PDF、Word(.doc/.docx)、Excel(.xls/.xlsx)

**响应**: `DocumentUploadResponse`

```json
{
  "filename": "文档.pdf",
  "chunks_processed": 15,
  "message": "成功上传并处理 文档.pdf，叶子分块 15 个，父级分块 5 个（存入docstore）"
}
```

---

### 3.3 删除文档

- **URL**: `DELETE /documents/{filename}`
- **描述**: 删除文档在 Milvus 中的向量数据（保留本地文件）
- **参数**:
  - `filename` (path): 文件名

**响应**: `DocumentDeleteResponse`

```json
{
  "filename": "文档.pdf",
  "chunks_deleted": 15,
  "message": "成功删除文档 文档.pdf 的向量数据（本地文件已保留）"
}
```

---

## 4. 数据模型定义

### 4.1 ChatRequest

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|------|------|------|--------|------|
| message | string | 是 | - | 用户消息 |
| user_id | string | 否 | "default_user" | 用户ID |
| session_id | string | 否 | "default_session" | 会话ID |

---

### 4.2 RagTrace (RAG 追踪信息)

| 字段 | 类型 | 说明 |
|------|------|------|
| tool_used | boolean | 是否使用工具 |
| tool_name | string | 工具名称 |
| query | string | 原始查询 |
| expanded_query | string | 扩展查询 |
| retrieval_mode | string | 检索模式 |
| retrieved_chunks | array | 检索到的文档块 |
| rerank_enabled | boolean | 是否启用重排序 |
| auto_merge_enabled | boolean | 是否启用自动合并 |

---

### 4.3 RetrievedChunk

| 字段 | 类型 | 说明 |
|------|------|------|
| filename | string | 文件名 |
| page_number | string/int | 页码 |
| text | string | 文本内容 |
| score | float | 相似度分数 |
| rrf_rank | int | RRF 排名 |
| rerank_score | float | 重排序分数 |

---

## 5. 错误码

| 状态码 | 说明 |
|--------|------|
| 400 | 请求参数错误（如文件类型不支持） |
| 404 | 资源不存在（如会话不存在） |
| 429 | 上游模型服务限流 |
| 500 | 服务器内部错误 |

---

## 6. 使用示例

### 6.1 发送对话请求

```javascript
const response = await fetch('http://localhost:8000/chat', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    message: '你好',
    user_id: 'user123',
    session_id: 'session456'
  })
});
const data = await response.json();
console.log(data.response);
```

---

### 6.2 流式对话

```javascript
const eventSource = new EventSource('http://localhost:8000/chat/stream', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    message: '你好',
    user_id: 'user123',
    session_id: 'session456'
  })
});

eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log(data.content);
};
```

---

### 6.3 上传文档

```javascript
const formData = new FormData();
formData.append('file', fileInput.files[0]);

const response = await fetch('http://localhost:8000/documents/upload', {
  method: 'POST',
  body: formData
});
const data = await response.json();
console.log(data.message);
```

---

## 7. API 端点汇总

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/sessions/{user_id}/{session_id}` | 获取会话消息 |
| GET | `/sessions/{user_id}` | 获取会话列表 |
| DELETE | `/sessions/{user_id}/{session_id}` | 删除会话 |
| POST | `/chat` | 普通对话 |
| POST | `/chat/stream` | 流式对话 |
| GET | `/documents` | 获取文档列表 |
| POST | `/documents/upload` | 上传文档 |
| DELETE | `/documents/{filename}` | 删除文档 |

---

*文档生成时间: 2026-03-28*  
*版本: 1.0*
