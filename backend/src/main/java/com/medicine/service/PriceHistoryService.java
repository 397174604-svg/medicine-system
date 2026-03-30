package com.medicine.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medicine.entity.PriceHistory;
import com.medicine.vo.ResultVO;

import java.util.List;

public interface PriceHistoryService extends IService<PriceHistory> {

    ResultVO<List<PriceHistory>> getAllPriceHistories();

    ResultVO<String> addPriceHistory(PriceHistory priceHistory);

    ResultVO<String> deletePriceHistory(Long id);
}
