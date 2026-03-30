package com.medicine.service;

import com.medicine.entity.SymptomMapping;
import com.medicine.vo.ResultVO;

import java.util.List;

public interface SymptomService {
    
    ResultVO<List<String>> getAllSymptoms();
    
    ResultVO<List<SymptomMapping>> getMedicinesBySymptom(String symptom);
    
    ResultVO<List<SymptomMapping>> searchBySymptomKeyword(String keyword);
}
