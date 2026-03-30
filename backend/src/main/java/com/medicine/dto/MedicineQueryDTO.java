package com.medicine.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MedicineQueryDTO {
    private String keyword;
    private String category;
    private String manufacturer;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private Boolean isPrescription;
    private String sortBy;
    private String sortOrder;
    private Integer pageNum = 1;
    private Integer pageSize = 20;
}
