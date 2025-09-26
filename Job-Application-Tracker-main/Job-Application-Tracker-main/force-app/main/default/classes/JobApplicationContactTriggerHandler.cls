public with sharing class JobApplicationContactTriggerHandler {
    public void setPrimaryContact(List<Job_Application_Contact__c> triggerDotNew) {
        Map<Id, Id> contactIdsByJobApplicationId = new Map<Id, Id>();

        for (Job_Application_Contact__c newJobApplicationContact : triggerDotNew) {
            if (!contactIdsByJobApplicationId.containsKey(newJobApplicationContact.Job_Application__c)) {
                contactIdsByJobApplicationId.put(newJobApplicationContact.Job_Application__c, newJobApplicationContact.Contact__c);
            }
        }

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Id, 
                Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :contactIdsByJobApplicationId.keySet() 
                AND Primary_Contact__c = null 
            WITH USER_MODE
        ];

        if (!jobApplicationsToUpdate.isEmpty()) {
            for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
                if (contactIdsByJobApplicationId.containsKey(jobApplicationToUpdate.Id)) {
                    jobApplicationToUpdate.Primary_Contact__c = contactIdsByJobApplicationId.get(jobApplicationToUpdate.Id);
                }
            }

            if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
                update as user jobApplicationsToUpdate;
            }
        }
    }
}