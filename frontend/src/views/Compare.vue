<template>
  <div class="compare-page">
    <el-card>
      <template #header>
        <div class="card-header">
          <h3>药品对比</h3>
          <p class="subtitle">选择两个药品进行详细对比</p>
        </div>
      </template>
      
      <div class="selection-area">
        <el-row :gutter="20">
          <el-col :span="10">
            <el-select
              v-model="selectedMedicine1"
              placeholder="选择第一个药品"
              filterable
              remote
              :remote-method="searchMedicines"
              :loading="searchLoading"
              style="width: 100%"
            >
              <el-option
                v-for="item in medicineOptions"
                :key="item.id"
                :label="item.name"
                :value="item"
              >
                <span>{{ item.name }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">{{ item.category }}</span>
              </el-option>
            </el-select>
          </el-col>
          <el-col :span="4" class="vs-text">
            <span>VS</span>
          </el-col>
          <el-col :span="10">
            <el-select
              v-model="selectedMedicine2"
              placeholder="选择第二个药品"
              filterable
              remote
              :remote-method="searchMedicines"
              :loading="searchLoading"
              style="width: 100%"
            >
              <el-option
                v-for="item in medicineOptions"
                :key="item.id"
                :label="item.name"
                :value="item"
              >
                <span>{{ item.name }}</span>
                <span style="float: right; color: #8492a6; font-size: 13px">{{ item.category }}</span>
              </el-option>
            </el-select>
          </el-col>
        </el-row>
        
        <div class="compare-btn">
          <el-button type="primary" size="large" @click="startCompare" :disabled="!canCompare">
            开始对比
          </el-button>
          <el-button size="large" @click="clearSelection">清空选择</el-button>
        </div>
      </div>
      
      <div v-if="compareResult.length > 0" class="compare-result">
        <el-table :data="compareData" border stripe>
          <el-table-column prop="property" label="对比项目" width="150" fixed />
          <el-table-column :label="selectedMedicine1?.name" min-width="300">
            <template #default="{ row }">
              <div v-html="formatValue(row.value1)"></div>
            </template>
          </el-table-column>
          <el-table-column :label="selectedMedicine2?.name" min-width="300">
            <template #default="{ row }">
              <div v-html="formatValue(row.value2)"></div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { queryMedicines } from '@/api/medicine'

const selectedMedicine1 = ref(null)
const selectedMedicine2 = ref(null)
const medicineOptions = ref([])
const searchLoading = ref(false)
const compareResult = ref([])

const canCompare = computed(() => {
  return selectedMedicine1.value && selectedMedicine2.value
})

const compareData = computed(() => {
  if (!selectedMedicine1.value || !selectedMedicine2.value) return []
  
  const m1 = selectedMedicine1.value
  const m2 = selectedMedicine2.value
  
  return [
    { property: '药品名称', value1: m1.name, value2: m2.name },
    { property: '通用名称', value1: m1.genericName, value2: m2.genericName },
    { property: '生产厂家', value1: m1.manufacturer, value2: m2.manufacturer },
    { property: '药品类别', value1: m1.category, value2: m2.category },
    { property: '规格', value1: m1.specifications, value2: m2.specifications },
    { property: '价格', value1: `¥${m1.price}`, value2: `¥${m2.price}`, highlight: true },
    { property: '评分', value1: `${m1.rating}分`, value2: `${m2.rating}分` },
    { property: '销量', value1: m1.sales, value2: m2.sales },
    { property: '适应症', value1: m1.indications, value2: m2.indications },
    { property: '用法', value1: m1.usageMethod, value2: m2.usageMethod },
    { property: '用量', value1: m1.dosage, value2: m2.dosage },
    { property: '注意事项', value1: m1.precautions, value2: m2.precautions },
    { property: '副作用', value1: m1.sideEffects, value2: m2.sideEffects },
    { property: '禁忌症', value1: m1.contraindications, value2: m2.contraindications }
  ]
})

const searchMedicines = async (query) => {
  if (query.length < 1) return
  
  searchLoading.value = true
  try {
    const res = await queryMedicines({
      keyword: query,
      pageNum: 1,
      pageSize: 20
    })
    medicineOptions.value = res.data.list
  } catch (error) {
    console.error(error)
  } finally {
    searchLoading.value = false
  }
}

const startCompare = () => {
  if (!canCompare.value) {
    ElMessage.warning('请选择两个药品进行对比')
    return
  }
  
  if (selectedMedicine1.value.id === selectedMedicine2.value.id) {
    ElMessage.warning('请选择两个不同的药品进行对比')
    return
  }
  
  compareResult.value = [selectedMedicine1.value, selectedMedicine2.value]
  ElMessage.success('对比成功')
}

const clearSelection = () => {
  selectedMedicine1.value = null
  selectedMedicine2.value = null
  compareResult.value = []
}

const formatValue = (value) => {
  if (!value) return '<span style="color: #909399">-</span>'
  return value
}
</script>

<style scoped>
.compare-page {
  max-width: 1200px;
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

.selection-area {
  padding: 20px 0;
}

.vs-text {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: bold;
  color: #f56c6c;
}

.compare-btn {
  text-align: center;
  margin-top: 30px;
}

.compare-result {
  margin-top: 30px;
}
</style>
