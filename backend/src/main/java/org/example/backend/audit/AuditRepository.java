package org.example.backend.audit;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuditRepository extends JpaRepository<Audit, Long> {
    @Query("SELECT r FROM Audit r WHERE r.department.id = :departmentId")
    List<Audit> findByDepartmentById(@Param("departmentId") Long departmentId);
}