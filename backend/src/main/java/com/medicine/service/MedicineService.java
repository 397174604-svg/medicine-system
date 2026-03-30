package com.medicine.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medicine.dto.MedicineQueryDTO;
import com.medicine.entity.Medicine;
import com.medicine.vo.PageVO;
import com.medicine.vo.ResultVO;

import java.util.List;
import java.util.Map;

public interface MedicineService extends IService<Medicine> {
    
    ResultVO<PageVO<Medicine>> queryMedicines(MedicineQueryDTO queryDTO);
    
    ResultVO<Medicine> getMedicineDetail(Long id);
    
    ResultVO<List<String>> getAllCategories();
    
    ResultVO<List<String>> getAllManufacturers();
    
    ResultVO<Map<String, List<Medicine>>> getRankings(Integer limit);
    
    ResultVO<List<Medicine>> compareMedicines(List<Long> medicineIds);
    
    ResultVO<String> addMedicine(Medicine medicine);
    
    ResultVO<String> updateMedicine(Medicine medicine);
    
    ResultVO<String> deleteMedicine(Long id);
}
