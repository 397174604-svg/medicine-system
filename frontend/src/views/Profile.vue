<template>
  <div class="profile-page">
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card>
          <template #header>
            <div class="card-header">
              <h3>个人信息</h3>
            </div>
          </template>
          
          <div class="user-info">
            <div class="avatar">
              <el-avatar :size="80" :icon="UserFilled" />
            </div>
            <h4>{{ userStore.userInfo?.username || '用户' }}</h4>
            <p class="role">{{ userStore.userInfo?.role || '普通用户' }}</p>
            <p class="join-date">注册时间: {{ formatDate(userStore.userInfo?.registerDate) }}</p>
          </div>
          
          <el-divider />
          
          <div class="user-stats">
            <div class="stat-item">
              <div class="stat-value">0</div>
              <div class="stat-label">收藏药品</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">0</div>
              <div class="stat-label">搜索记录</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">0</div>
              <div class="stat-label">评价记录</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="16">
        <el-card>
          <template #header>
            <div class="card-header">
              <h3>编辑资料</h3>
            </div>
          </template>
          
          <el-form :model="form" label-width="100px">
            <el-form-item label="用户名">
              <el-input v-model="form.username" disabled />
            </el-form-item>
            
            <el-form-item label="真实姓名">
              <el-input v-model="form.realName" placeholder="请输入真实姓名" />
            </el-form-item>
            
            <el-form-item label="邮箱">
              <el-input v-model="form.email" placeholder="请输入邮箱" />
            </el-form-item>
            
            <el-form-item label="手机号">
              <el-input v-model="form.phone" placeholder="请输入手机号" />
            </el-form-item>
            
            <el-form-item label="性别">
              <el-radio-group v-model="form.gender">
                <el-radio label="MALE">男</el-radio>
                <el-radio label="FEMALE">女</el-radio>
                <el-radio label="OTHER">其他</el-radio>
              </el-radio-group>
            </el-form-item>
            
            <el-form-item label="年龄">
              <el-input-number v-model="form.age" :min="1" :max="120" />
            </el-form-item>
            
            <el-form-item label="地址">
              <el-input v-model="form.address" type="textarea" :rows="2" placeholder="请输入地址" />
            </el-form-item>
            
            <el-form-item label="病史">
              <el-input v-model="form.medicalHistory" type="textarea" :rows="3" placeholder="请输入病史（选填）" />
            </el-form-item>
            
            <el-form-item label="过敏史">
              <el-input v-model="form.allergies" type="textarea" :rows="3" placeholder="请输入过敏史（选填）" />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="saveProfile">保存修改</el-button>
              <el-button @click="resetForm">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
        
        <el-card style="margin-top: 20px">
          <template #header>
            <div class="card-header">
              <h3>修改密码</h3>
            </div>
          </template>
          
          <el-form :model="passwordForm" label-width="100px">
            <el-form-item label="原密码">
              <el-input v-model="passwordForm.oldPassword" type="password" show-password placeholder="请输入原密码" />
            </el-form-item>
            
            <el-form-item label="新密码">
              <el-input v-model="passwordForm.newPassword" type="password" show-password placeholder="请输入新密码" />
            </el-form-item>
            
            <el-form-item label="确认密码">
              <el-input v-model="passwordForm.confirmPassword" type="password" show-password placeholder="请再次输入新密码" />
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" @click="changePassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-card>
        
        <!-- 文档管理 -->
        <el-card v-if="userStore.isAdmin" style="margin-top: 20px">
          <template #header>
            <div class="card-header">
              <h3>文档管理</h3>
              <el-button-group>
                <el-button type="primary" @click="refreshDocuments">
                  <el-icon><Refresh /></el-icon>刷新文件
                </el-button>
              </el-button-group>
            </div>
          </template>
          
          <div class="document-upload">
            <el-upload
              class="upload-demo"
              :auto-upload="false"
              :on-change="handleFileChange"
              :file-list="uploadFileList"
              accept=".pdf,.doc,.docx,.xls,.xlsx"
              drag
            >
              <el-icon class="el-icon--upload"><Upload /></el-icon>
              <div class="el-upload__text">拖放文件到此处，或<em>点击上传</em></div>
              <template #tip>
                <div class="el-upload__tip">
                  支持上传 PDF、Word 和 Excel 文档
                </div>
              </template>
            </el-upload>
            <el-button type="success" @click="uploadDocument" :disabled="!uploadFileList.length">
              <el-icon><Upload /></el-icon>确认上传
            </el-button>
          </div>
          
          <el-divider />
          
          <div class="document-list">
            <el-table :data="documents" style="width: 100%">
              <el-table-column prop="filename" label="文件名" width="300" />
              <el-table-column prop="file_type" label="文件类型" width="120" />
              <el-table-column prop="chunk_count" label="分块数量" width="120" />
              <el-table-column label="操作" width="150">
                <template #default="scope">
                  <el-button type="danger" size="small" @click="deleteDocument(scope.row.filename)">
                    <el-icon><Delete /></el-icon>删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
            <el-empty v-if="documents.length === 0" description="暂无文档" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElLoading } from 'element-plus'
import { UserFilled, Refresh, Upload, Delete } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

const form = reactive({
  username: '',
  realName: '',
  email: '',
  phone: '',
  gender: '',
  age: null,
  address: '',
  medicalHistory: '',
  allergies: ''
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 文档管理相关状态
const documents = ref([])
const uploadFileList = ref([])

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('zh-CN')
}

const loadUserInfo = () => {
  const userInfo = userStore.userInfo
  if (userInfo) {
    Object.assign(form, userInfo)
  }
}

const saveProfile = () => {
  // 调用API保存用户信息
  ElMessage.success('保存成功')
}

const resetForm = () => {
  loadUserInfo()
}

const changePassword = () => {
  if (!passwordForm.oldPassword || !passwordForm.newPassword || !passwordForm.confirmPassword) {
    ElMessage.warning('请填写完整信息')
    return
  }
  
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  
  // 调用API修改密码
  ElMessage.success('密码修改成功')
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
}

// 文档管理方法
const refreshDocuments = async () => {
  const loading = ElLoading.service({
    lock: true,
    text: '加载文档列表中...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  try {
    const response = await fetch('/documents')
    if (response.ok) {
      const data = await response.json()
      documents.value = data.documents
    } else {
      ElMessage.error('获取文档列表失败')
    }
  } catch (error) {
    console.error('获取文档列表错误:', error)
    ElMessage.error('获取文档列表失败')
  } finally {
    loading.close()
  }
}

const handleFileChange = (file, fileList) => {
  uploadFileList.value = fileList
}

const uploadDocument = async () => {
  if (uploadFileList.value.length === 0) {
    ElMessage.warning('请选择要上传的文件')
    return
  }
  
  const loading = ElLoading.service({
    lock: true,
    text: '上传文件中...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  try {
    for (const file of uploadFileList.value) {
      const formData = new FormData()
      formData.append('file', file.raw)
      
      const response = await fetch('/documents/upload', {
        method: 'POST',
        body: formData
      })
      
      if (response.ok) {
        const data = await response.json()
        ElMessage.success(`文件 ${data.filename} 上传成功`)
      } else {
        ElMessage.error(`文件 ${file.name} 上传失败`)
      }
    }
    
    // 上传完成后刷新文档列表
    await refreshDocuments()
    uploadFileList.value = []
  } catch (error) {
    console.error('上传文件错误:', error)
    ElMessage.error('上传文件失败')
  } finally {
    loading.close()
  }
}

const deleteDocument = async (filename) => {
  try {
    const response = await fetch(`/documents/${encodeURIComponent(filename)}`, {
      method: 'DELETE'
    })
    
    if (response.ok) {
      const data = await response.json()
      ElMessage.success(`文件 ${data.filename} 删除成功`)
      await refreshDocuments()
    } else {
      ElMessage.error('删除文件失败')
    }
  } catch (error) {
    console.error('删除文件错误:', error)
    ElMessage.error('删除文件失败')
  }
}

onMounted(() => {
  loadUserInfo()
  // 如果是管理员，加载文档列表
  if (userStore.isAdmin) {
    refreshDocuments()
  }
})
</script>

<style scoped>
.profile-page {
  max-width: 1200px;
  margin: 0 auto;
}

.card-header {
  text-align: center;
}

.card-header h3 {
  margin: 0;
}

.user-info {
  text-align: center;
  padding: 20px 0;
}

.avatar {
  margin-bottom: 15px;
}

.user-info h4 {
  margin: 0 0 8px 0;
  color: #303133;
}

.role {
  color: #409eff;
  font-size: 14px;
  margin: 0 0 8px 0;
}

.join-date {
  color: #909399;
  font-size: 12px;
  margin: 0;
}

.user-stats {
  display: flex;
  justify-content: space-around;
  padding: 10px 0;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #409eff;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.document-upload {
  margin-bottom: 20px;
}

.document-upload .upload-demo {
  margin-bottom: 15px;
}

.document-list {
  margin-top: 20px;
}
</style>
