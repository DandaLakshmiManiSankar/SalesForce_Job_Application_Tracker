trigger JobApplicationContactTrigger on Job_Application_Contact__c (after insert, after update) {
    JobApplicationContactTriggerHandler jobApplicationContactTriggerHandler = new JobApplicationContactTriggerHandler();

    switch on Trigger.operationType {
        when AFTER_INSERT {
            jobApplicationContactTriggerHandler.setPrimaryContact(Trigger.new);
        }

        when AFTER_UPDATE {
            jobApplicationContactTriggerHandler.setPrimaryContact(Trigger.new);
        }
    }
}