import request from '@/utils/request'

export const queryMedicines = (data) => {
  return request.post('/medicine/query', data)
}

export const getMedicineDetail = (id) => {
  return request.get(`/medicine/${id}`)
}

export const getCategories = () => {
  return request.get('/medicine/categories')
}

export const getManufacturers = () => {
  return request.get('/medicine/manufacturers')
}

export const getRankings = (limit = 20) => {
  return request.get('/medicine/rankings', { params: { limit } })
}

export const compareMedicines = (medicineIds) => {
  return request.post('/medicine/compare', medicineIds)
}
