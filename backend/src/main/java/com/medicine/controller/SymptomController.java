package com.medicine.controller;

import com.medicine.entity.SymptomMapping;
import com.medicine.service.SymptomService;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/symptom")
@CrossOrigin(origins = "*")
public class SymptomController {

    @Autowired
    private SymptomService symptomService;

    @GetMapping("/all")
    public ResultVO<List<String>> getAllSymptoms() {
        return symptomService.getAllSymptoms();
    }

    @GetMapping("/{symptom}")
    public ResultVO<List<SymptomMapping>> getMedicinesBySymptom(@PathVariable String symptom) {
        return symptomService.getMedicinesBySymptom(symptom);
    }

    @GetMapping("/search")
    public ResultVO<List<SymptomMapping>> searchBySymptomKeyword(@RequestParam String keyword) {
        return symptomService.searchBySymptomKeyword(keyword);
    }
}
