package org.example.backend.audit;

import java.time.LocalDate;

public class AuditDTO {

    private Long id;
    private Long departmentId;
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

    public Long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
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