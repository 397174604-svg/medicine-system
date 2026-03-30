<template>
  <div class="search-page">
    <el-card class="search-card">
      <template #header>
        <div class="card-header">
          <h3>药品查询</h3>
        </div>
      </template>
      
      <el-form :model="searchForm" inline>
        <el-form-item label="关键词">
          <el-input 
            v-model="searchForm.keyword" 
            placeholder="药品名称/通用名"
            clearable
            style="width: 200px"
          />
        </el-form-item>
        
        <el-form-item label="类别">
          <el-select 
            v-model="searchForm.category" 
            placeholder="全部类别"
            clearable
            style="width: 150px"
          >
            <el-option label="全部" value="" />
            <el-option 
              v-for="cat in categories" 
              :key="cat" 
              :label="cat" 
              :value="cat" 
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="价格范围">
          <el-input-number 
            v-model="searchForm.minPrice" 
            :min="0" 
            placeholder="最低价"
            style="width: 120px"
          />
          <span style="margin: 0 8px">-</span>
          <el-input-number 
            v-model="searchForm.maxPrice" 
            :min="0" 
            placeholder="最高价"
            style="width: 120px"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <el-card class="result-card">
      <template #header>
        <div class="card-header">
          <h3>搜索结果</h3>
          <span class="result-count">共 {{ total }} 条记录</span>
        </div>
      </template>
      
      <el-table :data="medicineList" v-loading="loading" stripe>
        <el-table-column prop="name" label="药品名称" min-width="150">
          <template #default="{ row }">
            <el-link type="primary" @click="showDetail(row)">{{ row.name }}</el-link>
          </template>
        </el-table-column>
        <el-table-column prop="genericName" label="通用名称" min-width="120" />
        <el-table-column prop="manufacturer" label="生产厂家" min-width="180" show-overflow-tooltip />
        <el-table-column prop="category" label="类别" width="100" />
        <el-table-column prop="specifications" label="规格" width="120" />
        <el-table-column prop="price" label="价格" width="100">
          <template #default="{ row }">
            <span style="color: #f56c6c; font-weight: bold">¥{{ row.price }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="rating" label="评分" width="100">
          <template #default="{ row }">
            <el-rate :model-value="row.rating" disabled show-score />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="showDetail(row)">详情</el-button>
            <el-button type="success" size="small" @click="addToCompare(row)">对比</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="searchForm.pageNum"
          v-model:page-size="searchForm.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
    
    <!-- 药品详情对话框 -->
    <el-dialog v-model="detailVisible" title="药品详情" width="700px">
      <el-descriptions :column="2" border v-if="currentMedicine">
        <el-descriptions-item label="药品名称" :span="2">{{ currentMedicine.name }}</el-descriptions-item>
        <el-descriptions-item label="通用名称">{{ currentMedicine.genericName }}</el-descriptions-item>
        <el-descriptions-item label="英文名称">{{ currentMedicine.englishName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="生产厂家">{{ currentMedicine.manufacturer }}</el-descriptions-item>
        <el-descriptions-item label="药品类别">{{ currentMedicine.category }}</el-descriptions-item>
        <el-descriptions-item label="规格">{{ currentMedicine.specifications }}</el-descriptions-item>
        <el-descriptions-item label="价格">
          <span style="color: #f56c6c; font-size: 18px; font-weight: bold">¥{{ currentMedicine.price }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="评分">
          <el-rate :model-value="currentMedicine.rating" disabled show-score />
        </el-descriptions-item>
        <el-descriptions-item label="适应症" :span="2">{{ currentMedicine.indications }}</el-descriptions-item>
        <el-descriptions-item label="用法" :span="2">{{ currentMedicine.usageMethod }}</el-descriptions-item>
        <el-descriptions-item label="用量" :span="2">{{ currentMedicine.dosage }}</el-descriptions-item>
        <el-descriptions-item label="注意事项" :span="2">{{ currentMedicine.precautions }}</el-descriptions-item>
        <el-descriptions-item label="副作用" :span="2">{{ currentMedicine.sideEffects }}</el-descriptions-item>
        <el-descriptions-item label="禁忌症" :span="2">{{ currentMedicine.contraindications }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { queryMedicines, getCategories, getMedicineDetail } from '@/api/medicine'

const loading = ref(false)
const medicineList = ref([])
const categories = ref([])
const total = ref(0)
const detailVisible = ref(false)
const currentMedicine = ref(null)

const searchForm = reactive({
  keyword: '',
  category: '',
  minPrice: null,
  maxPrice: null,
  pageNum: 1,
  pageSize: 20
})

const fetchCategories = async () => {
  try {
    const res = await getCategories()
    categories.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const fetchMedicines = async () => {
  loading.value = true
  try {
    const res = await queryMedicines(searchForm)
    medicineList.value = res.data.list
    total.value = res.data.total
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  searchForm.pageNum = 1
  fetchMedicines()
}

const handleReset = () => {
  searchForm.keyword = ''
  searchForm.category = ''
  searchForm.minPrice = null
  searchForm.maxPrice = null
  searchForm.pageNum = 1
  fetchMedicines()
}

const handleSizeChange = (val) => {
  searchForm.pageSize = val
  fetchMedicines()
}

const handleCurrentChange = (val) => {
  searchForm.pageNum = val
  fetchMedicines()
}

const showDetail = async (row) => {
  try {
    const res = await getMedicineDetail(row.id)
    currentMedicine.value = res.data
    detailVisible.value = true
  } catch (error) {
    console.error(error)
  }
}

const addToCompare = (row) => {
  // 添加到对比列表的逻辑
  ElMessage.success(`已将 ${row.name} 添加到对比列表`)
}

onMounted(() => {
  fetchCategories()
  fetchMedicines()
})
</script>

<style scoped>
.search-page {
  max-width: 1400px;
  margin: 0 auto;
}

.search-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
}

.result-count {
  color: #909399;
  font-size: 14px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
