package com.medicine.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medicine.dto.MedicineQueryDTO;
import com.medicine.entity.Medicine;
import com.medicine.mapper.MedicineMapper;
import com.medicine.service.MedicineService;
import com.medicine.vo.PageVO;
import com.medicine.vo.ResultVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MedicineServiceImpl extends ServiceImpl<MedicineMapper, Medicine> implements MedicineService {

    @Override
    public ResultVO<PageVO<Medicine>> queryMedicines(MedicineQueryDTO queryDTO) {
        Page<Medicine> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        
        LambdaQueryWrapper<Medicine> wrapper = new LambdaQueryWrapper<>();
        
        // 关键词搜索
        if (StringUtils.isNotBlank(queryDTO.getKeyword())) {
            wrapper.and(w -> w.like(Medicine::getName, queryDTO.getKeyword())
                    .or()
                    .like(Medicine::getGenericName, queryDTO.getKeyword()));
        }
        
        // 类别筛选
        if (StringUtils.isNotBlank(queryDTO.getCategory()) && !"全部".equals(queryDTO.getCategory())) {
            wrapper.eq(Medicine::getCategory, queryDTO.getCategory());
        }
        
        // 生产厂家筛选
        if (StringUtils.isNotBlank(queryDTO.getManufacturer())) {
            wrapper.like(Medicine::getManufacturer, queryDTO.getManufacturer());
        }
        
        // 价格范围
        if (queryDTO.getMinPrice() != null) {
            wrapper.ge(Medicine::getPrice, queryDTO.getMinPrice());
        }
        if (queryDTO.getMaxPrice() != null) {
            wrapper.le(Medicine::getPrice, queryDTO.getMaxPrice());
        }
        
        // 处方药筛选
        if (queryDTO.getIsPrescription() != null) {
            wrapper.eq(Medicine::getIsPrescription, queryDTO.getIsPrescription());
        }
        
        // 排序
        if ("price".equals(queryDTO.getSortBy())) {
            if ("asc".equalsIgnoreCase(queryDTO.getSortOrder())) {
                wrapper.orderByAsc(Medicine::getPrice);
            } else {
                wrapper.orderByDesc(Medicine::getPrice);
            }
        } else if ("sales".equals(queryDTO.getSortBy())) {
            wrapper.orderByDesc(Medicine::getSales);
        } else if ("rating".equals(queryDTO.getSortBy())) {
            wrapper.orderByDesc(Medicine::getRating);
        } else {
            wrapper.orderByDesc(Medicine::getSales);
        }
        
        IPage<Medicine> result = baseMapper.selectPage(page, wrapper);
        
        PageVO<Medicine> pageVO = new PageVO<>(result.getRecords(), result.getTotal(), 
                (int) result.getCurrent(), (int) result.getSize());
        
        return ResultVO.success(pageVO);
    }

    @Override
    public ResultVO<Medicine> getMedicineDetail(Long id) {
        Medicine medicine = baseMapper.selectById(id);
        if (medicine == null) {
            return ResultVO.error("药品不存在");
        }
        return ResultVO.success(medicine);
    }

    @Override
    public ResultVO<List<String>> getAllCategories() {
        List<String> categories = baseMapper.selectAllCategories();
        return ResultVO.success(categories);
    }

    @Override
    public ResultVO<List<String>> getAllManufacturers() {
        List<String> manufacturers = baseMapper.selectAllManufacturers();
        return ResultVO.success(manufacturers);
    }

    @Override
    public ResultVO<Map<String, List<Medicine>>> getRankings(Integer limit) {
        if (limit == null || limit <= 0) {
            limit = 20;
        }
        
        Map<String, List<Medicine>> rankings = new HashMap<>();
        rankings.put("sales", baseMapper.selectTopBySales(limit));
        rankings.put("price", baseMapper.selectTopByPrice(limit));
        rankings.put("rating", baseMapper.selectTopByRating(limit));
        
        return ResultVO.success(rankings);
    }

    @Override
    public ResultVO<List<Medicine>> compareMedicines(List<Long> medicineIds) {
        if (medicineIds == null || medicineIds.size() < 2) {
            return ResultVO.error("请至少选择两个药品进行对比");
        }
        
        List<Medicine> medicines = baseMapper.selectBatchIds(medicineIds);
        return ResultVO.success(medicines);
    }

    @Override
    public ResultVO<String> addMedicine(Medicine medicine) {
        baseMapper.insert(medicine);
        return ResultVO.success("添加成功");
    }

    @Override
    public ResultVO<String> updateMedicine(Medicine medicine) {
        baseMapper.updateById(medicine);
        return ResultVO.success("更新成功");
    }

    @Override
    public ResultVO<String> deleteMedicine(Long id) {
        baseMapper.deleteById(id);
        return ResultVO.success("删除成功");
    }
}
