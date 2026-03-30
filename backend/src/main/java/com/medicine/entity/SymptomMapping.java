package com.medicine.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("symptom_mappings")
public class SymptomMapping {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String symptom;
    private Long medicineId;
    private Integer recommendationLevel;
    private String description;
    private String severity;
    private String advice;
    
    @TableField(exist = false)
    private Medicine medicine;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
