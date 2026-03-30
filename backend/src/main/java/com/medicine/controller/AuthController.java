package com.medicine.controller;

import com.medicine.dto.LoginDTO;
import com.medicine.dto.LoginResponseDTO;
import com.medicine.dto.RegisterDTO;
import com.medicine.service.UserService;
import com.medicine.vo.ResultVO;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResultVO<LoginResponseDTO> login(@Valid @RequestBody LoginDTO loginDTO) {
        return userService.login(loginDTO);
    }

    @PostMapping("/register")
    public ResultVO<String> register(@Valid @RequestBody RegisterDTO registerDTO) {
        return userService.register(registerDTO);
    }
}
