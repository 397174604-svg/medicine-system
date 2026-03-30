package com.medicine.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medicine.dto.LoginDTO;
import com.medicine.dto.LoginResponseDTO;
import com.medicine.dto.RegisterDTO;
import com.medicine.entity.User;
import com.medicine.vo.ResultVO;

public interface UserService extends IService<User> {
    
    ResultVO<LoginResponseDTO> login(LoginDTO loginDTO);
    
    ResultVO<String> register(RegisterDTO registerDTO);
    
    ResultVO<User> getUserInfo(Long userId);
    
    ResultVO<String> updateUserInfo(User user);
    
    User getUserByUsername(String username);
    
    ResultVO<String> changePassword(Long userId, String oldPassword, String newPassword);
}
