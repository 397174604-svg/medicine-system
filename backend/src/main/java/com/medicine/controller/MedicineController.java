package com.medicine.controller;

import com.medicine.dto.MedicineQueryDTO;
import com.medicine.entity.Medicine;
import com.medicine.service.MedicineService;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/medicine")
@CrossOrigin(origins = "*")
public class MedicineController {

    @Autowired
    private MedicineService medicineService;

    @PostMapping("/query")
    public ResultVO<?> queryMedicines(@RequestBody MedicineQueryDTO queryDTO) {
        return medicineService.queryMedicines(queryDTO);
    }

    @GetMapping("/{id}")
    public ResultVO<Medicine> getMedicineDetail(@PathVariable Long id) {
        return medicineService.getMedicineDetail(id);
    }

    @GetMapping("/categories")
    public ResultVO<List<String>> getAllCategories() {
        return medicineService.getAllCategories();
    }

    @GetMapping("/manufacturers")
    public ResultVO<List<String>> getAllManufacturers() {
        return medicineService.getAllManufacturers();
    }

    @GetMapping("/rankings")
    public ResultVO<Map<String, List<Medicine>>> getRankings(@RequestParam(defaultValue = "20") Integer limit) {
        return medicineService.getRankings(limit);
    }

    @PostMapping("/compare")
    public ResultVO<List<Medicine>> compareMedicines(@RequestBody List<Long> medicineIds) {
        return medicineService.compareMedicines(medicineIds);
    }

    @PostMapping
    public ResultVO<String> addMedicine(@RequestBody Medicine medicine) {
        return medicineService.addMedicine(medicine);
    }

    @PutMapping("/{id}")
    public ResultVO<String> updateMedicine(@PathVariable Long id, @RequestBody Medicine medicine) {
        medicine.setId(id);
        return medicineService.updateMedicine(medicine);
    }

    @DeleteMapping("/{id}")
    public ResultVO<String> deleteMedicine(@PathVariable Long id) {
        return medicineService.deleteMedicine(id);
    }
}
