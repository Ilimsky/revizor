package org.example.backend.audit;

import org.example.backend.department.Department;
import org.springframework.stereotype.Component;

@Component
public class AuditMapper {

    public AuditDTO toDTO(Audit audit) {
        AuditDTO dto = new AuditDTO();
        dto.setId(audit.getId());
        dto.setDepartmentId(audit.getDepartment().getId());
        dto.setAuditNumber(audit.getAuditNumber());
        dto.setDepartmentIdentifier(audit.getDepartmentIdentifier());

        dto.setDateReceived(audit.getDateReceived());
        dto.setAmountIssued(audit.getAmountIssued());
        dto.setDateApproved(audit.getDateApproved());
        dto.setPurpose(audit.getPurpose());
        dto.setRecognizedAmount(audit.getRecognizedAmount());
        dto.setComments(audit.getComments());
        return dto;
    }

    public Audit toEntity(AuditDTO dto, Department department) {
        Audit audit = new Audit();
        audit.setDepartment(department);
        audit.setAuditNumber(dto.getAuditNumber());
        audit.setDepartmentIdentifier(dto.getDepartmentIdentifier());

        // Новые поля
        audit.setDateReceived(dto.getDateReceived());
        audit.setAmountIssued(dto.getAmountIssued());
        audit.setDateApproved(dto.getDateApproved());
        audit.setPurpose(dto.getPurpose());
        audit.setRecognizedAmount(dto.getRecognizedAmount());
        audit.setComments(dto.getComments());

        return audit;
    }
}