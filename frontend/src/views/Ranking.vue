<template>
  <div class="ranking-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h3>药品排行榜</h3>
        </div>
      </template>
      
      <el-tabs v-model="activeTab" type="border-card">
        <el-tab-pane label="销量排行" name="sales">
          <el-table :data="rankings.sales" stripe v-loading="loading">
            <el-table-column type="index" label="排名" width="80" align="center">
              <template #default="{ $index }">
                <el-tag :type="getRankType($index)" effect="dark">{{ $index + 1 }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="name" label="药品名称" min-width="150" />
            <el-table-column prop="genericName" label="通用名称" min-width="120" />
            <el-table-column prop="category" label="类别" width="100" />
            <el-table-column prop="sales" label="销量" width="100" sortable>
              <template #default="{ row }">
                <span style="color: #409eff; font-weight: bold">{{ row.sales }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="price" label="销售额" width="120">
              <template #default="{ row }">
                <span style="color: #f56c6c; font-weight: bold">¥{{ (row.sales * row.price).toFixed(2) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" fixed="right">
              <template #default="{ row }">
                <el-button type="primary" size="small" @click="showDetail(row)">详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="价格排行" name="price">
          <el-table :data="rankings.price" stripe v-loading="loading">
            <el-table-column type="index" label="排名" width="80" align="center">
              <template #default="{ $index }">
                <el-tag :type="getRankType($index)" effect="dark">{{ $index + 1 }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="name" label="药品名称" min-width="150" />
            <el-table-column prop="genericName" label="通用名称" min-width="120" />
            <el-table-column prop="category" label="类别" width="100" />
            <el-table-column prop="price" label="价格" width="120" sortable>
              <template #default="{ row }">
                <span style="color: #f56c6c; font-weight: bold; font-size: 16px">¥{{ row.price }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="manufacturer" label="生产厂家" min-width="180" show-overflow-tooltip />
            <el-table-column label="操作" width="120" fixed="right">
              <template #default="{ row }">
                <el-button type="primary" size="small" @click="showDetail(row)">详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="评分排行" name="rating">
          <el-table :data="rankings.rating" stripe v-loading="loading">
            <el-table-column type="index" label="排名" width="80" align="center">
              <template #default="{ $index }">
                <el-tag :type="getRankType($index)" effect="dark">{{ $index + 1 }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="name" label="药品名称" min-width="150" />
            <el-table-column prop="genericName" label="通用名称" min-width="120" />
            <el-table-column prop="category" label="类别" width="100" />
            <el-table-column prop="rating" label="评分" width="150">
              <template #default="{ row }">
                <el-rate :model-value="row.rating" disabled show-score />
              </template>
            </el-table-column>
            <el-table-column prop="sales" label="销量" width="100" />
            <el-table-column label="操作" width="120" fixed="right">
              <template #default="{ row }">
                <el-button type="primary" size="small" @click="showDetail(row)">详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    
    <!-- 药品详情对话框 -->
    <el-dialog v-model="detailVisible" title="药品详情" width="700px">
      <el-descriptions :column="2" border v-if="currentMedicine">
        <el-descriptions-item label="药品名称" :span="2">{{ currentMedicine.name }}</el-descriptions-item>
        <el-descriptions-item label="通用名称">{{ currentMedicine.genericName }}</el-descriptions-item>
        <el-table-column prop="manufacturer" label="生产厂家" min-width="180" show-overflow-tooltip />
        <el-descriptions-item label="类别">{{ currentMedicine.category }}</el-descriptions-item>
        <el-descriptions-item label="规格">{{ currentMedicine.specifications }}</el-descriptions-item>
        <el-descriptions-item label="价格">
          <span style="color: #f56c6c; font-size: 18px; font-weight: bold">¥{{ currentMedicine.price }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="评分">
          <el-rate :model-value="currentMedicine.rating" disabled show-score />
        </el-descriptions-item>
        <el-descriptions-item label="销量">{{ currentMedicine.sales }}</el-descriptions-item>
        <el-descriptions-item label="适应症" :span="2">{{ currentMedicine.indications }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getRankings, getMedicineDetail } from '@/api/medicine'

const activeTab = ref('sales')
const loading = ref(false)
const detailVisible = ref(false)
const currentMedicine = ref(null)

const rankings = reactive({
  sales: [],
  price: [],
  rating: []
})

const getRankType = (index) => {
  if (index === 0) return 'danger'
  if (index === 1) return 'warning'
  if (index === 2) return 'success'
  return 'info'
}

const fetchRankings = async () => {
  loading.value = true
  try {
    const res = await getRankings(20)
    Object.assign(rankings, res.data)
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
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

onMounted(() => {
  fetchRankings()
})
</script>

<style scoped>
.ranking-page {
  max-width: 1200px;
  margin: 0 auto;
}

.card-header {
  text-align: center;
}

.card-header h3 {
  margin: 0;
}
</style>
