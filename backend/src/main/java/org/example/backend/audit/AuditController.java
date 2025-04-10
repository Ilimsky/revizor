package org.example.backend.audit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/audits")
@CrossOrigin(origins = "*")
public class AuditController {

    private final AuditServiceImpl auditServiceImpl;

    @Autowired
    public AuditController(AuditServiceImpl auditServiceImpl) {
        this.auditServiceImpl = auditServiceImpl;
    }

    @GetMapping
    public ResponseEntity<List<AuditDTO>> getAllAudits() {
        List<AuditDTO> audits = auditServiceImpl.getAllAudits();
        return ResponseEntity.ok(audits);
    }


    @PostMapping
    public ResponseEntity<AuditDTO> createAudit(@RequestBody AuditDTO auditDTO) {
        AuditDTO createdAudit = auditServiceImpl.createAudit(auditDTO);
        return new ResponseEntity<>(createdAudit, HttpStatus.CREATED);
    }

    @GetMapping("/department/{departmentId}")
    public ResponseEntity<List<AuditDTO>> getAuditsByIds(@PathVariable Long departmentId) {
        List<AuditDTO> auditsByIds = auditServiceImpl.getAuditsByIds(departmentId);
        return ResponseEntity.ok(auditsByIds);
    }

    @GetMapping("/{auditId}")
    public ResponseEntity<AuditDTO> getAuditById(@PathVariable Long auditId) {
        Optional<AuditDTO> auditById = Optional.ofNullable(auditServiceImpl.getAuditById(auditId));
        return auditById.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{auditId}")
    public ResponseEntity<AuditDTO> updateAudit(@PathVariable Long auditId, @RequestBody AuditDTO updatedAuditDTO) {
        AuditDTO updatedAudit = auditServiceImpl.updateAudit(auditId, updatedAuditDTO);
        return new ResponseEntity<>(updatedAudit, HttpStatus.OK);
    }

    @DeleteMapping("/{auditId}")
    public ResponseEntity<Void> deleteAudit(@PathVariable Long auditId) {
        auditServiceImpl.deleteAudit(auditId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @DeleteMapping("/department/{departmentId}")
    public ResponseEntity<Void> deleteAuditsByIds(@PathVariable Long departmentId) {
        auditServiceImpl.deleteAuditsByIds(departmentId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}