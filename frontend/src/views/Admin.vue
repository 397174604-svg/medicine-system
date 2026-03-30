<template>
  <div class="admin-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h3>管理员功能</h3>
          <p class="subtitle">系统管理控制台</p>
        </div>
      </template>
      
      <!-- 数据统计卡片 -->
      <el-row :gutter="20" style="margin-bottom: 20px">
        <el-col :span="8">
          <el-card class="stat-card">
            <div class="stat-icon" style="background-color: #409eff">
              <el-icon :size="32" color="#fff"><FirstAidKit /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.medicineCount }}</div>
              <div class="stat-label">药品总数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card class="stat-card">
            <div class="stat-icon" style="background-color: #67c23a">
              <el-icon :size="32" color="#fff"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.userCount }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </el-card>
        </el-col>

      </el-row>
      
      <!-- 药品管理 -->
      <el-card style="margin-bottom: 20px">
        <template #header>
          <div class="card-title">
            <h4>药品管理</h4>
            <el-button type="primary" @click="dialogs.medicineVisible = true">添加药品</el-button>
          </div>
        </template>
        <el-table :data="medicines" style="width: 100%">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="name" label="药品名称" />
          <el-table-column prop="category" label="类别" width="120" />
          <el-table-column prop="price" label="价格" width="100" />
          <el-table-column prop="stock" label="库存" width="100" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button type="primary" size="small" @click="editMedicine(scope.row)">编辑</el-button>
              <el-button type="danger" size="small" @click="deleteMedicine(scope.row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
      
      <!-- 用户管理 -->
      <el-card style="margin-bottom: 20px">
        <template #header>
          <div class="card-title">
            <h4>用户管理</h4>
            <el-button type="primary" @click="dialogs.userVisible = true">添加用户</el-button>
          </div>
        </template>
        <el-table :data="users" style="width: 100%">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="role" label="角色" width="120">
            <template #default="scope">
              {{ scope.row.role === 'ADMIN' ? '管理员' : '普通用户' }}
            </template>
          </el-table-column>
          <el-table-column prop="active" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.active ? 'success' : 'danger'">
                {{ scope.row.active ? '启用' : '禁用' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button type="primary" size="small" @click="editUser(scope.row)">编辑</el-button>
              <el-button type="danger" size="small" @click="deleteUser(scope.row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
      

    </el-card>
    
    <!-- 药品管理对话框 -->
    <el-dialog v-model="dialogs.medicineVisible" :title="editingMedicine ? '编辑药品' : '添加药品'" width="800px">
      <div class="dialog-content">
        <el-row :gutter="20" style="margin-bottom: 20px">
          <el-col :span="12">
            <el-input v-model="medicineForm.name" placeholder="药品名称" />
          </el-col>
          <el-col :span="12">
            <el-input v-model="medicineForm.category" placeholder="药品类别" />
          </el-col>
        </el-row>
        <el-row :gutter="20" style="margin-bottom: 20px">
          <el-col :span="12">
            <el-input v-model="medicineForm.price" type="number" placeholder="价格" />
          </el-col>
          <el-col :span="12">
            <el-input v-model="medicineForm.stock" type="number" placeholder="库存" />
          </el-col>
        </el-row>
        <el-input
          v-model="medicineForm.indications"
          type="textarea"
          placeholder="适应症"
          :rows="3"
          style="margin-bottom: 20px"
        />
        <el-button type="primary" @click="saveMedicine">保存药品</el-button>
        <el-button @click="dialogs.medicineVisible = false">取消</el-button>
      </div>
    </el-dialog>
    
    <!-- 用户管理对话框 -->
    <el-dialog v-model="dialogs.userVisible" :title="editingUser ? '编辑用户' : '添加用户'" width="800px">
      <div class="dialog-content">
        <el-row :gutter="20" style="margin-bottom: 20px">
          <el-col :span="12">
            <el-input v-model="userForm.username" placeholder="用户名" />
          </el-col>
          <el-col :span="12">
            <el-select v-model="userForm.role" placeholder="角色">
              <el-option label="管理员" value="ADMIN" />
              <el-option label="普通用户" value="USER" />
            </el-select>
          </el-col>
        </el-row>
        <el-row :gutter="20" style="margin-bottom: 20px">
          <el-col :span="12">
            <el-input v-model="userForm.password" type="password" placeholder="密码" />
          </el-col>
          <el-col :span="12">
            <el-switch v-model="userForm.active" active-text="启用" inactive-text="禁用" />
          </el-col>
        </el-row>
        <el-button type="primary" @click="saveUser">保存用户</el-button>
        <el-button @click="dialogs.userVisible = false">取消</el-button>
      </div>
    </el-dialog>
    

  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  FirstAidKit,
  User,
  Document
} from '@element-plus/icons-vue'

// 统计数据
const stats = reactive({
  medicineCount: 0,
  userCount: 0
})

// 对话框状态
const dialogs = reactive({
  medicineVisible: false,
  userVisible: false
})

// 编辑状态
const editingMedicine = ref(null)
const editingUser = ref(null)

// 药品表单
const medicineForm = reactive({
  id: '',
  name: '',
  category: '',
  price: '',
  stock: '',
  indications: ''
})

// 用户表单
const userForm = reactive({
  id: '',
  username: '',
  password: '',
  role: 'USER',
  active: true
})

// 数据列表
const medicines = ref([])
const users = ref([])

// API 基础URL
const API_BASE = '/api'

// 获取药品列表
const fetchMedicines = async () => {
  try {
    const response = await fetch(`${API_BASE}/medicine/query`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({})
    })
    const data = await response.json()
    if (data.code === 200) {
      medicines.value = Array.isArray(data.data?.list) ? data.data.list : []
      stats.medicineCount = medicines.value.length
    } else {
      medicines.value = []
      stats.medicineCount = 0
    }
  } catch (error) {
    console.error('获取药品列表失败:', error)
    medicines.value = []
    stats.medicineCount = 0
  }
}

// 获取用户列表
const fetchUsers = async () => {
  try {
    const response = await fetch(`${API_BASE}/user`)
    const data = await response.json()
    if (data.code === 200) {
      users.value = Array.isArray(data.data) ? data.data : []
      stats.userCount = users.value.length
    } else {
      users.value = []
      stats.userCount = 0
    }
  } catch (error) {
    console.error('获取用户列表失败:', error)
    users.value = []
    stats.userCount = 0
  }
}

// 编辑药品
const editMedicine = (medicine) => {
  Object.assign(medicineForm, medicine)
  editingMedicine.value = medicine
  dialogs.medicineVisible = true
}

// 编辑用户
const editUser = (user) => {
  Object.assign(userForm, user)
  editingUser.value = user
  dialogs.userVisible = true
}

// 保存药品
const saveMedicine = async () => {
  if (!medicineForm.name || !medicineForm.category || !medicineForm.price) {
    ElMessage.warning('请填写完整的药品信息')
    return
  }
  
  try {
    let response
    if (editingMedicine.value) {
      // 编辑现有药品
      response = await fetch(`${API_BASE}/medicine/${medicineForm.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(medicineForm)
      })
    } else {
      // 添加新药品
      response = await fetch(`${API_BASE}/medicine`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(medicineForm)
      })
    }
    
    const data = await response.json()
    if (data.code === 200) {
      ElMessage.success(data.message || (editingMedicine.value ? '编辑成功' : '添加成功'))
      dialogs.medicineVisible = false
      resetMedicineForm()
      await fetchMedicines()
    } else {
      ElMessage.error(data.message || '操作失败')
    }
  } catch (error) {
    console.error('保存药品失败:', error)
    ElMessage.error('保存失败，请稍后重试')
  }
}

// 保存用户
const saveUser = async () => {
  if (!userForm.username || !userForm.password) {
    ElMessage.warning('请填写完整的用户信息')
    return
  }
  
  try {
    let response
    if (editingUser.value) {
      // 编辑现有用户
      response = await fetch(`${API_BASE}/user/${userForm.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(userForm)
      })
    } else {
      // 添加新用户
      response = await fetch(`${API_BASE}/user`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(userForm)
      })
    }
    
    const data = await response.json()
    if (data.code === 200) {
      ElMessage.success(data.message || (editingUser.value ? '编辑成功' : '添加成功'))
      dialogs.userVisible = false
      resetUserForm()
      await fetchUsers()
    } else {
      ElMessage.error(data.message || '操作失败')
    }
  } catch (error) {
    console.error('保存用户失败:', error)
    ElMessage.error('保存失败，请稍后重试')
  }
}

// 删除药品
const deleteMedicine = async (id) => {
  ElMessageBox.confirm('确定要删除这个药品吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const response = await fetch(`${API_BASE}/medicine/${id}`, {
        method: 'DELETE'
      })
      
      const data = await response.json()
      if (data.code === 200) {
        ElMessage.success('药品删除成功')
        await fetchMedicines()
      } else {
        ElMessage.error(data.message || '删除失败')
      }
    } catch (error) {
      console.error('删除药品失败:', error)
      ElMessage.error('删除失败，请稍后重试')
    }
  }).catch(() => {
    // 取消删除
  })
}

// 删除用户
const deleteUser = async (id) => {
  ElMessageBox.confirm('确定要删除这个用户吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const response = await fetch(`${API_BASE}/user/${id}`, {
        method: 'DELETE'
      })
      
      const data = await response.json()
      if (data.code === 200) {
        ElMessage.success('用户删除成功')
        await fetchUsers()
      } else {
        ElMessage.error(data.message || '删除失败')
      }
    } catch (error) {
      console.error('删除用户失败:', error)
      ElMessage.error('删除失败，请稍后重试')
    }
  }).catch(() => {
    // 取消删除
  })
}

// 重置药品表单
const resetMedicineForm = () => {
  Object.keys(medicineForm).forEach(key => {
    medicineForm[key] = ''
  })
  editingMedicine.value = null
}

// 重置用户表单
const resetUserForm = () => {
  Object.keys(userForm).forEach(key => {
    userForm[key] = ''
  })
  userForm.role = 'USER'
  userForm.active = true
  editingUser.value = null
}

// 页面加载时初始化数据
onMounted(async () => {
  await fetchMedicines()
  await fetchUsers()
})
</script>

<style scoped>
.admin-page {
  max-width: 1400px;
  margin: 0 auto;
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

.card-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title h4 {
  margin: 0;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 10px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.dialog-content {
  padding: 20px 0;
}
</style>
