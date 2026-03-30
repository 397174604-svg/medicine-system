package com.medicine.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medicine.entity.SymptomMapping;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SymptomMappingMapper extends BaseMapper<SymptomMapping> {
    
    @Select("SELECT DISTINCT symptom FROM symptom_mappings ORDER BY symptom")
    List<String> selectAllSymptoms();
    
    @Select("SELECT sm.*, m.* FROM symptom_mappings sm " +
            "LEFT JOIN medicines m ON sm.medicine_id = m.id " +
            "WHERE sm.symptom = #{symptom} " +
            "ORDER BY sm.recommendation_level DESC")
    List<SymptomMapping> selectBySymptom(@Param("symptom") String symptom);
    
    @Select("SELECT sm.*, m.* FROM symptom_mappings sm " +
            "LEFT JOIN medicines m ON sm.medicine_id = m.id " +
            "WHERE sm.symptom LIKE CONCAT('%', #{keyword}, '%') " +
            "ORDER BY sm.recommendation_level DESC")
    List<SymptomMapping> selectBySymptomLike(@Param("keyword") String keyword);
}
