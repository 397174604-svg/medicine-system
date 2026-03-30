package com.medicine;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@MapperScan("com.medicine.mapper")
@EnableCaching
public class MedicineSystemApplication {
    public static void main(String[] args) {
        SpringApplication.run(MedicineSystemApplication.class, args);
    }
}
