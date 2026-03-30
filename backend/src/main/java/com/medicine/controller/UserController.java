package com.medicine.controller;

import com.medicine.entity.User;
import com.medicine.service.UserService;
import com.medicine.vo.ResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public ResultVO<List<User>> getAllUsers() {
        return ResultVO.success(userService.list());
    }

    @PostMapping
    public ResultVO<String> addUser(@RequestBody User user) {
        return userService.save(user) ? ResultVO.success("添加成功") : ResultVO.error("添加失败");
    }

    @PutMapping("/{id}")
    public ResultVO<String> updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        return userService.updateById(user) ? ResultVO.success("更新成功") : ResultVO.error("更新失败");
    }

    @DeleteMapping("/{id}")
    public ResultVO<String> deleteUser(@PathVariable Long id) {
        return userService.removeById(id) ? ResultVO.success("删除成功") : ResultVO.error("删除失败");
    }

    @GetMapping("/{id}")
    public ResultVO<User> getUserById(@PathVariable Long id) {
        return ResultVO.success(userService.getById(id));
    }
}
