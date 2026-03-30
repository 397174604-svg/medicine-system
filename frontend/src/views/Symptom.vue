<template>
  <div class="symptom-page">
    <el-card class="chat-card">
      <template #header>
        <div class="card-header">
          <h3>智能医疗助手</h3>
          <p class="subtitle">请描述您的症状或健康问题，我将为您提供专业建议</p>
        </div>
      </template>
      
      <div class="chat-container">
        <!-- 聊天消息区域 -->
        <div class="chat-messages" ref="messageContainer">
          <div 
            v-for="(message, index) in messages" 
            :key="index"
            :class="['message-item', message.type === 'user' ? 'user-message' : 'ai-message']"
          >
            <div class="message-avatar">
              <el-avatar :size="40" :icon="message.type === 'user' ? User : ChatLineSquare" />
            </div>
            <div class="message-content">
              <div class="message-text" style="white-space: pre-wrap; word-wrap: break-word;">{{ message.content }}</div>
              <div class="message-time">{{ message.timestamp }}</div>
            </div>
          </div>
          <div v-if="isLoading" class="loading-message">
            <div class="message-avatar">
              <el-avatar :size="40" :icon="ChatLineSquare" />
            </div>
            <div class="message-content">
              <div class="typing-indicator">
                <span class="dot"></span>
                <span class="dot"></span>
                <span class="dot"></span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 输入区域 -->
        <div class="chat-input-area">
          <el-input
            v-model="messageInput"
            placeholder="请输入您的症状或健康问题..."
            size="large"
            clearable
            @keyup.enter="sendMessage"
          >
            <template #append>
              <el-button 
                type="primary" 
                @click="sendMessage"
                :disabled="isLoading || !messageInput.trim()"
              >
                <el-icon><Message /></el-icon>发送
              </el-button>
            </template>
          </el-input>
        </div>
        
        <!-- 快捷问题 -->
        <div class="quick-questions">
          <span class="label">常见问题：</span>
          <el-tag
            v-for="question in quickQuestions"
            :key="question"
            class="quick-question-tag"
            type="info"
            effect="plain"
            @click="selectQuickQuestion(question)"
          >
            {{ question }}
          </el-tag>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { User, ChatLineSquare, Message, Search } from '@element-plus/icons-vue'

const messageInput = ref('')
const messages = ref([])
const isLoading = ref(false)
const messageContainer = ref(null)

const quickQuestions = [
  '我感冒了应该吃什么药？',
  '头痛怎么办？',
  '胃痛怎么缓解？',
  '过敏症状如何处理？',
  '失眠怎么改善？'
]

// 发送消息
const sendMessage = async () => {
  if (!messageInput.value.trim()) {
    ElMessage.warning('请输入消息内容')
    return
  }
  
  const userMessage = {
    type: 'user',
    content: messageInput.value.trim(),
    timestamp: new Date().toLocaleString()
  }
  
  messages.value.push(userMessage)
  messageInput.value = ''
  isLoading.value = true
  
  // 滚动到底部
  await nextTick()
  scrollToBottom()
  
  try {
    await streamChat(userMessage.content)
  } catch (error) {
    console.error('聊天失败:', error)
    ElMessage.error('聊天失败，请重试')
    isLoading.value = false
  }
}

// 流式聊天
const streamChat = async (message) => {
  console.log('开始流式聊天请求...')
  
  // 直接使用普通的fetch，不使用AbortController，避免过早取消
  try {
    const response = await fetch('/chat/stream', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        message: message,
        user_id: 'default_user',
        session_id: 'symptom_session'
      })
    })
    
    console.log('流式聊天请求成功，开始处理响应...')
    
    if (!response.ok) {
      console.error('流式聊天请求失败:', response.status)
      throw new Error(`流式聊天请求失败: ${response.status}`)
    }
    
    const reader = response.body.getReader()
    const decoder = new TextDecoder()
    let aiMessage = {
      type: 'ai',
      content: '',
      timestamp: ''
    }
    
    messages.value.push(aiMessage)
    await nextTick()
    scrollToBottom()
    
    console.log('开始读取流式响应...')
    
    let receivedChunks = 0
    let lastUpdateTime = 0
    
    while (true) {
      const { done, value } = await reader.read()
      
      if (done) {
        console.log('流式响应结束')
        break
      }
      
      receivedChunks++
      console.log(`收到第 ${receivedChunks} 个数据块`)
      
      const chunk = decoder.decode(value, { stream: true })
      const lines = chunk.split('\n')
      
      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const dataStr = line.substring(6)
          if (dataStr === '[DONE]') {
            console.log('收到结束信号')
            aiMessage.timestamp = new Date().toLocaleString()
            isLoading.value = false
            await nextTick()
            scrollToBottom()
            return
          }
          
          try {
            const data = JSON.parse(dataStr)
            console.log('收到数据:', data)
            
            if (data.type === 'content' && data.content) {
              // 累积内容
              aiMessage.content += data.content
              
              // 立即更新DOM，确保流式效果
              const now = Date.now()
              if (now - lastUpdateTime > 16) { // 约60fps
                lastUpdateTime = now
                await nextTick()
                scrollToBottom()
              }
            } else if (data.type === 'error') {
              console.error('流式错误:', data.content)
              ElMessage.error(data.content)
              isLoading.value = false
              return
            }
          } catch (e) {
            console.error('解析SSE数据失败:', e, '数据:', dataStr)
          }
        }
      }
    }
    
    // 正常结束但没有收到 [DONE]
    console.log('流式响应完成，没有收到结束信号')
    aiMessage.timestamp = new Date().toLocaleString()
    isLoading.value = false
    await nextTick()
    scrollToBottom()
    
  } catch (error) {
    console.error('流式聊天错误:', error)
    ElMessage.error('聊天失败，请重试')
    isLoading.value = false
  }
}

// 选择快捷问题
const selectQuickQuestion = (question) => {
  messageInput.value = question
  sendMessage()
}

// 滚动到底部
const scrollToBottom = () => {
  if (messageContainer.value) {
    messageContainer.value.scrollTop = messageContainer.value.scrollHeight
  }
}

// 页面加载时添加欢迎消息
onMounted(() => {
  const welcomeMessage = {
    type: 'ai',
    content: '您好！我是智能医疗助手，很高兴为您服务。请描述您的症状或健康问题，我将为您提供专业的医疗建议。',
    timestamp: new Date().toLocaleString()
  }
  messages.value.push(welcomeMessage)
  scrollToBottom()
})
</script>

<style scoped>
.symptom-page {
  max-width: 800px;
  margin: 0 auto;
}

.chat-card {
  margin-bottom: 20px;
}

.card-header {
  text-align: center;
}

.card-header h3 {
  margin: 0 0 8px 0;
}

.subtitle {
  margin: 0;
  color: #909399;
  font-size: 14px;
}

.chat-container {
  display: flex;
  flex-direction: column;
  height: 600px;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin-bottom: 20px;
}

.message-item {
  display: flex;
  margin-bottom: 20px;
  animation: fadeIn 0.3s ease-in-out;
}

.user-message {
  flex-direction: row-reverse;
}

.message-avatar {
  margin: 0 10px;
}

.message-content {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 18px;
  position: relative;
}

.user-message .message-content {
  background-color: #409eff;
  color: white;
  border-bottom-right-radius: 4px;
}

.ai-message .message-content {
  background-color: white;
  color: #303133;
  border-bottom-left-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.message-text {
  word-wrap: break-word;
  line-height: 1.5;
}

.message-time {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
  text-align: right;
}

.user-message .message-time {
  color: rgba(255, 255, 255, 0.7);
}

.loading-message {
  display: flex;
  margin-bottom: 20px;
}

.typing-indicator {
  display: flex;
  align-items: center;
  gap: 5px;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: #909399;
  animation: typing 1.4s infinite ease-in-out both;
}

.dot:nth-child(1) {
  animation-delay: -0.32s;
}

.dot:nth-child(2) {
  animation-delay: -0.16s;
}

.chat-input-area {
  margin-bottom: 20px;
}

.quick-questions {
  text-align: center;
}

.quick-questions .label {
  color: #606266;
  margin-right: 10px;
}

.quick-question-tag {
  margin: 0 5px 5px 0;
  cursor: pointer;
}

.quick-question-tag:hover {
  background-color: #409eff;
  color: #fff;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes typing {
  0%, 80%, 100% {
    transform: scale(0);
  }
  40% {
    transform: scale(1);
  }
}
</style>
