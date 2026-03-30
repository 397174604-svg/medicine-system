import request from '@/utils/request'

export const getAllSymptoms = () => {
  return request.get('/symptom/all')
}

export const getMedicinesBySymptom = (symptom) => {
  return request.get(`/symptom/${symptom}`)
}

export const searchBySymptomKeyword = (keyword) => {
  return request.get('/symptom/search', { params: { keyword } })
}
