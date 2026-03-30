package com.medicine.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medicine.entity.Medicine;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface MedicineMapper extends BaseMapper<Medicine> {
    
    @Select("SELECT DISTINCT category FROM medicines ORDER BY category")
    List<String> selectAllCategories();
    
    @Select("SELECT DISTINCT manufacturer FROM medicines ORDER BY manufacturer")
    List<String> selectAllManufacturers();
    
    IPage<Medicine> selectByCondition(Page<Medicine> page, 
                                      @Param("keyword") String keyword,
                                      @Param("category") String category,
                                      @Param("manufacturer") String manufacturer,
                                      @Param("minPrice") BigDecimal minPrice,
                                      @Param("maxPrice") BigDecimal maxPrice,
                                      @Param("isPrescription") Boolean isPrescription);
    
    @Select("SELECT * FROM medicines ORDER BY sales DESC LIMIT #{limit}")
    List<Medicine> selectTopBySales(Integer limit);
    
    @Select("SELECT * FROM medicines ORDER BY price DESC LIMIT #{limit}")
    List<Medicine> selectTopByPrice(Integer limit);
    
    @Select("SELECT * FROM medicines ORDER BY rating DESC LIMIT #{limit}")
    List<Medicine> selectTopByRating(Integer limit);
}
