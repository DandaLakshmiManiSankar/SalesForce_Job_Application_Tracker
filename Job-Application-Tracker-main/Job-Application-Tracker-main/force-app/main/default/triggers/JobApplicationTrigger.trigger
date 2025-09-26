trigger JobApplicationTrigger on Job_Application__c (before insert, before update, after insert, after update) {
    JobApplicationTriggerHandler jobApplicationTriggerHandler = new JobApplicationTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            jobApplicationTriggerHandler.validateApplicationAndFollowUpDate(Trigger.new);
            jobApplicationTriggerHandler.setPrimaryContact(Trigger.new);
            TaxCalculation.calculatePayrollTaxes(Trigger.new);
        }

        when BEFORE_UPDATE {
            jobApplicationTriggerHandler.validateApplicationAndFollowUpDate(Trigger.new);
            jobApplicationTriggerHandler.setPrimaryContact(Trigger.new);
            TaxCalculation.calculatePayrollTaxes(Trigger.new);
        }

        when AFTER_INSERT {
            jobApplicationTriggerHandler.createTask_Insert(Trigger.new);
        }

        when AFTER_UPDATE {
            jobApplicationTriggerHandler.createTask_Update(Trigger.oldMap, Trigger.new);
        }
    }
}