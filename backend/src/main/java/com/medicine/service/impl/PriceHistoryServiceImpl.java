package com.medicine.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medicine.entity.PriceHistory;
import com.medicine.mapper.PriceHistoryMapper;
import com.medicine.service.PriceHistoryService;
import com.medicine.vo.ResultVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PriceHistoryServiceImpl extends ServiceImpl<PriceHistoryMapper, PriceHistory> implements PriceHistoryService {

    @Override
    public ResultVO<List<PriceHistory>> getAllPriceHistories() {
        return ResultVO.success(list());
    }

    @Override
    public ResultVO<String> addPriceHistory(PriceHistory priceHistory) {
        return save(priceHistory) ? ResultVO.success("添加成功") : ResultVO.error("添加失败");
    }

    @Override
    public ResultVO<String> deletePriceHistory(Long id) {
        return removeById(id) ? ResultVO.success("删除成功") : ResultVO.error("删除失败");
    }
}
