package com.medicine.controller;

import com.medicine.entity.PriceHistory;
import com.medicine.service.PriceHistoryService;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/price-history")
@CrossOrigin(origins = "*")
public class PriceHistoryController {

    @Autowired
    private PriceHistoryService priceHistoryService;

    @GetMapping
    public ResultVO<?> getAllPriceHistories() {
        return priceHistoryService.getAllPriceHistories();
    }

    @PostMapping
    public ResultVO<String> addPriceHistory(@RequestBody PriceHistory priceHistory) {
        return priceHistoryService.addPriceHistory(priceHistory);
    }

    @DeleteMapping("/{id}")
    public ResultVO<String> deletePriceHistory(@PathVariable Long id) {
        return priceHistoryService.deletePriceHistory(id);
    }
}
