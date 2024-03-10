package sn.thiare.appmanagement.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sn.thiare.appmanagement.entity.Student;
import sn.thiare.appmanagement.service.StudentService;


import java.text.MessageFormat;
import java.util.List;

@RestController
@RequestMapping("/api/v1/students")
@RequiredArgsConstructor
public class StudentsRestController {
    private final StudentService studentService;

    @GetMapping
    public List<Student> findAll() {
        return (List<Student>) studentService.findAll();
    }

    @GetMapping("/{email}")
    public Student findByEmail(@PathVariable String email) {
        return studentService.findByEmail(email).orElseThrow(
                () -> new IllegalArgumentException(MessageFormat.format("No student with given email was found: {0}", email)
                ));
    }
}
