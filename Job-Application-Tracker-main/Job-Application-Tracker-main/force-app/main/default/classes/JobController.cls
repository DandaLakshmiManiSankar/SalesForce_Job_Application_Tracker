public with sharing class JobController {
    @AuraEnabled(cacheable=true)
    public static List<Job__c> queryJobs() {
        return [
            SELECT 
                Id, 
                Title__c, 
                Company__c, 
                Location__c, 
                Type__c, 
                Salary__c, 
                Snippet__c, 
                Link__c, 
                Source__c, 
                Updated__c, 
                Id__c 
            FROM Job__c 
            WITH USER_MODE
        ];
    }

    @AuraEnabled
    public static void deleteJobs(List<String> recordIds) {
        if (Schema.sObjectType.Job__c.isDeletable()) {
            delete as user [SELECT Id FROM Job__c WHERE Id IN :recordIds WITH USER_MODE];
        }
    }

    @AuraEnabled
    public static void deleteAllJobs() {
        if (Schema.sObjectType.Job__c.isDeletable()) {
            delete as user [SELECT Id FROM Job__c WITH USER_MODE];
        }
    }
}