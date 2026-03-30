package com.medicine.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medicine.dto.LoginDTO;
import com.medicine.dto.LoginResponseDTO;
import com.medicine.dto.RegisterDTO;
import com.medicine.entity.User;
import com.medicine.mapper.UserMapper;
import com.medicine.service.UserService;
import com.medicine.utils.JwtUtil;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public ResultVO<LoginResponseDTO> login(LoginDTO loginDTO) {
        User user = baseMapper.selectByUsername(loginDTO.getUsername());
        
        if (user == null) {
            return ResultVO.error("用户名或密码错误");
        }
        
        if (!user.getIsActive()) {
            return ResultVO.error("该账户已被禁用，请联系管理员");
        }
        
        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            return ResultVO.error("用户名或密码错误");
        }
        
        // 更新最后登录时间
        user.setLastLoginDate(LocalDateTime.now());
        baseMapper.updateById(user);
        
        // 清除敏感信息
        user.setPassword(null);
        
        // 生成JWT token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
        
        LoginResponseDTO responseDTO = new LoginResponseDTO(token, user);
        return ResultVO.success("登录成功", responseDTO);
    }

    @Override
    @Transactional
    public ResultVO<String> register(RegisterDTO registerDTO) {
        // 验证密码是否一致
        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            return ResultVO.error("两次输入的密码不一致");
        }
        
        // 检查用户名是否已存在
        if (baseMapper.selectByUsername(registerDTO.getUsername()) != null) {
            return ResultVO.error("用户名已存在");
        }
        
        // 检查邮箱是否已存在
        if (registerDTO.getEmail() != null && baseMapper.selectByEmail(registerDTO.getEmail()) != null) {
            return ResultVO.error("邮箱已被注册");
        }
        
        // 创建新用户
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setEmail(registerDTO.getEmail());
        user.setPhone(registerDTO.getPhone());
        user.setRole("USER");
        user.setIsActive(true);
        user.setRegisterDate(LocalDateTime.now());
        user.setLastLoginDate(LocalDateTime.now());
        
        baseMapper.insert(user);
        
        return ResultVO.success("注册成功");
    }

    @Override
    public ResultVO<User> getUserInfo(Long userId) {
        User user = baseMapper.selectById(userId);
        if (user == null) {
            return ResultVO.error("用户不存在");
        }
        // 清除敏感信息
        user.setPassword(null);
        return ResultVO.success(user);
    }

    @Override
    public ResultVO<String> updateUserInfo(User user) {
        User existingUser = baseMapper.selectById(user.getId());
        if (existingUser == null) {
            return ResultVO.error("用户不存在");
        }
        
        // 不允许修改用户名和密码
        user.setUsername(null);
        user.setPassword(null);
        user.setRole(null);
        
        baseMapper.updateById(user);
        return ResultVO.success("更新成功");
    }

    @Override
    public User getUserByUsername(String username) {
        return baseMapper.selectByUsername(username);
    }

    @Override
    public ResultVO<String> changePassword(Long userId, String oldPassword, String newPassword) {
        User user = baseMapper.selectById(userId);
        if (user == null) {
            return ResultVO.error("用户不存在");
        }
        
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return ResultVO.error("原密码错误");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        baseMapper.updateById(user);
        
        return ResultVO.success("密码修改成功");
    }
}
