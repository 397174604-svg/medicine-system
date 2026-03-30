package com.medicine.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("users")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String username;
    private String password;
    private String email;
    private String phone;
    private String role;
    private Boolean isActive;
    private LocalDateTime registerDate;
    private LocalDateTime lastLoginDate;
    
    // 用户资料
    private String realName;
    private Integer age;
    private String gender;
    private String medicalHistory;
    private String allergies;
    private String address;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
