package com.medicine.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("medicines")
public class Medicine {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    private String genericName;
    private String englishName;
    private String manufacturer;
    private String manufacturerQualification;
    private String description;
    private String indications;
    private String usageMethod;
    private String dosage;
    private String precautions;
    private String sideEffects;
    private String contraindications;
    private String allergicReactions;
    private String batchNumber;
    private LocalDate expiryDate;
    private String specifications;
    private String category;
    private String drugType;
    private String storageCondition;
    private Boolean isPrescription;
    
    // 业务字段
    private BigDecimal price;
    private Integer stock;
    private Integer sales;
    private BigDecimal rating;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdDate;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateDate;
}
