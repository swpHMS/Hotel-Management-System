/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author DieuBHHE191686
 */
public class EmailTemplate {
    private int templateId;
    private String code;
    private String subject;
    private String content;
    private boolean active;

    public EmailTemplate() {
    }

    public EmailTemplate(int templateId, String code, String subject, String content, boolean active) {
        this.templateId = templateId;
        this.code = code;
        this.subject = subject;
        this.content = content;
        this.active = active;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
    
    
}
