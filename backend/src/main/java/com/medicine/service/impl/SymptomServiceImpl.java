package com.medicine.service.impl;

import com.medicine.entity.SymptomMapping;
import com.medicine.mapper.SymptomMappingMapper;
import com.medicine.service.SymptomService;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SymptomServiceImpl implements SymptomService {

    @Autowired
    private SymptomMappingMapper symptomMappingMapper;

    @Override
    public ResultVO<List<String>> getAllSymptoms() {
        List<String> symptoms = symptomMappingMapper.selectAllSymptoms();
        return ResultVO.success(symptoms);
    }

    @Override
    public ResultVO<List<SymptomMapping>> getMedicinesBySymptom(String symptom) {
        List<SymptomMapping> mappings = symptomMappingMapper.selectBySymptom(symptom);
        return ResultVO.success(mappings);
    }

    @Override
    public ResultVO<List<SymptomMapping>> searchBySymptomKeyword(String keyword) {
        List<SymptomMapping> mappings = symptomMappingMapper.selectBySymptomLike(keyword);
        return ResultVO.success(mappings);
    }
}
