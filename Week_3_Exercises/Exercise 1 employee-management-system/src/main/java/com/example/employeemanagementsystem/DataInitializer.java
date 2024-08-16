package com.example.employeemanagementsystem;

import com.example.employeemanagementsystem.model.Department;
import com.example.employeemanagementsystem.model.Employee;
import com.example.employeemanagementsystem.repository.DepartmentRepository;
import com.example.employeemanagementsystem.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    @Override
    public void run(String... args) throws Exception {
        // Create departments
        Department hr = new Department();
        hr.setName("Human Resources");
        departmentRepository.save(hr);

        Department it = new Department();
        it.setName("Information Technology");
        departmentRepository.save(it);

        // Create employees
        Employee john = new Employee();
        john.setFirstName("John");
        john.setLastName("Doe");
        john.setEmail("john.doe@example.com");
        john.setDepartment(hr);
        employeeRepository.save(john);

        Employee jane = new Employee();
        jane.setFirstName("Jane");
        jane.setLastName("Smith");
        jane.setEmail("jane.smith@example.com");
        jane.setDepartment(it);
        employeeRepository.save(jane);
    }
}