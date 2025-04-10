package org.example.backend.department;

import org.springframework.stereotype.Component;

@Component
public class DepartmentMapper {

    public DepartmentDTO toDTO(Department department) {
        if (department == null) {
            return null;
        }

        return new DepartmentDTO(
                department.getId(),
                department.getName()
        );
    }

    public Department toEntity(DepartmentDTO departmentDTO) {
        if (departmentDTO == null) {
            return null;
        }

        Department department = new Department();
        department.setId(departmentDTO.getId());
        department.setName(departmentDTO.getName());

        return department;
    }
}