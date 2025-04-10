package org.example.backend.audit;

import jakarta.persistence.*;
import org.example.backend.department.Department;

import java.time.LocalDate;

@Entity
public class Audit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Department department;

    private int auditNumber;
    private Long departmentIdentifier;

    private LocalDate dateReceived;
    private String amountIssued;
    private LocalDate dateApproved;
    private String purpose;
    private String recognizedAmount;
    private String comments;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public int getAuditNumber() {
        return auditNumber;
    }

    public void setAuditNumber(int auditNumber) {
        this.auditNumber = auditNumber;
    }

    public Long getDepartmentIdentifier() {
        return departmentIdentifier;
    }

    public void setDepartmentIdentifier(Long departmentIdentifier) {
        this.departmentIdentifier = departmentIdentifier;
    }


    public LocalDate getDateReceived() {
        return dateReceived;
    }

    public void setDateReceived(LocalDate dateReceived) {
        this.dateReceived = dateReceived;
    }

    public String getAmountIssued() {
        return amountIssued;
    }

    public void setAmountIssued(String amountIssued) {
        this.amountIssued = amountIssued;
    }

    public LocalDate getDateApproved() {
        return dateApproved;
    }

    public void setDateApproved(LocalDate dateApproved) {
        this.dateApproved = dateApproved;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getRecognizedAmount() {
        return recognizedAmount;
    }

    public void setRecognizedAmount(String recognizedAmount) {
        this.recognizedAmount = recognizedAmount;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
}