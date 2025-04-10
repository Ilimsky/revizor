package org.example.backend.audit;

import java.util.List;

public interface AuditService {
    AuditDTO createAudit(AuditDTO auditDTO);

    List<AuditDTO> getAllAudits();

    List<AuditDTO> getAuditsByIds(Long departmentId);

    AuditDTO getAuditById(Long auditId);

    AuditDTO updateAudit(Long auditId, AuditDTO updatedAuditDTO);

    void deleteAudit(Long auditId);

    void deleteAuditsByIds(Long departmentId);
}