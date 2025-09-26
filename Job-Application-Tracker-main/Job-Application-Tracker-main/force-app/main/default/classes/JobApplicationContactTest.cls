@IsTest
private with sharing class JobApplicationContactTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    private static final List<String> POSITION_TITLES = new List<String>{
        'jobApplicationBlackthorn', 
        'jobApplicationHTS', 
        'jobApplicationBAH', 
        'jobApplicationSalesforce'
    };

    @TestSetup
    private static void setup() {
        List<Account> acctsToInsert = testDataFactory.createAccts_setup_JobApplicationTest_JobApplicationContactTest();

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user acctsToInsert;
        }

        Id accBlackthornId;
        Id accHTSId;
        Id accBAHId;
        Id accSalesforceId;

        for (Account accToInsert : acctsToInsert) {
            if (accToInsert.Name == 'Blackthorn') {
                accBlackthornId = accToInsert.Id;
            } else if (accToInsert.Name == 'Hudson Technology Systems') {
                accHTSId = accToInsert.Id;
            } else if (accToInsert.Name == 'Booz Allen Hamilton') {
                accBAHId = accToInsert.Id;
            } else if (accToInsert.Name == 'Salesforce') {
                accSalesforceId = accToInsert.Id;
            }
        }

        List<Contact> contactsToInsert = testDataFactory.createContacts_setup_JobApplicationTest_JobApplicationContactTest();

        if (Schema.sObjectType.Contact.isCreateable()) {
            insert as user contactsToInsert;
        }

        Id contactThornieId;
        Id contactHudsonId;

        for (Contact contactToInsert : contactsToInsert) {
            if (contactToInsert.LastName == 'Thornie') {
                contactThornieId = contactToInsert.Id;
            } else if (contactToInsert.LastName == 'Hudson') {
                contactHudsonId = contactToInsert.Id;
            }
        }

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_setup_JobApplicationContactTest(
            accBlackthornId, 
            contactThornieId, 
            accHTSId, 
            contactHudsonId, 
            accBAHId, 
            accSalesforceId
        );

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

    }

    @IsTest
    private static void update_job_application_primary_contact_on_insert() {
        // GIVEN
        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        Map<String, Id> jobApplicationIdMap = getJobApplicationIdMap();

        Id jobApplicationBlackthornId = jobApplicationIdMap.get('jobApplicationBlackthorn');
        Id jobApplicationHTSId = jobApplicationIdMap.get('jobApplicationHTS');
        Id jobApplicationBAHId = jobApplicationIdMap.get('jobApplicationBAH');
        Id jobApplicationSalesforceId = jobApplicationIdMap.get('jobApplicationSalesforce');

        List<Job_Application_Contact__c> jobApplicationContacts = testDataFactory.createJobApplicationContacts_setPrimaryContact_JobApplicationContactTest(
            contactBoozId, 
            contactBearId, 
            jobApplicationBlackthornId, 
            jobApplicationHTSId, 
            jobApplicationBAHId, 
            jobApplicationSalesforceId
        );

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application_Contact__c.isCreateable()) {
            insert as user jobApplicationContacts;
        }

        Test.stopTest();

        // THEN
        List<Job_Application__c> retrievedJobApplications = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Position_Title__c IN :POSITION_TITLES 
            WITH USER_MODE
        ];

        List<Job_Application__c> retrievedJobApplications_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplications) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplications_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplications_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplications_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplications_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(1, retrievedJobApplications_Thornie.size(), 'Expect 1 job application with Thornie as primary contact');
        System.assertEquals(1, retrievedJobApplications_Hudson.size(), 'Expect 1 job application with Hudson as primary contact');
        System.assertEquals(1, retrievedJobApplications_Booz.size(), 'Expect 1 job application with Booz as primary contact');
        System.assertEquals(1, retrievedJobApplications_Bear.size(), 'Expect 1 job application with Bear as primary contact');
    }

    private static Map<String, Id> getAccIdMap() {
        final List<String> NAMES = new List<String>{
            'Blackthorn', 
            'Hudson Technology Systems', 
            'Booz Allen Hamilton', 
            'Salesforce'
        };

        List<Account> retrievedAccts = [
            SELECT 
                Id, 
                Name 
            FROM Account 
            WHERE Name IN :NAMES 
            WITH USER_MODE
        ];

        Map<String, Id> accIdMap = new Map<String, Id>();

        for (Account retrievedAcct : retrievedAccts) {
            if (retrievedAcct.Name == 'Blackthorn') {
                accIdMap.put('Blackthorn', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Hudson Technology Systems') {
                accIdMap.put('HTS', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Booz Allen Hamilton') {
                accIdMap.put('BAH', retrievedAcct.Id);
            } else if (retrievedAcct.Name == 'Salesforce') {
                accIdMap.put('Salesforce', retrievedAcct.Id);
            }
        }

        return accIdMap;
    }

    private static Map<String, Id> getContactIdMap() {
        final List<String> LAST_NAMES = new List<String>{
            'Thornie', 
            'Hudson', 
            'Booz', 
            'Bear'
        };

        List<Contact> retrievedContacts = [
            SELECT 
                Id, 
                LastName 
            FROM Contact 
            WHERE LastName IN :LAST_NAMES 
            WITH USER_MODE
        ];

        Map<String, Id> contactIdMap = new Map<String, Id>();

        for (Contact retrievedContact : retrievedContacts) {
            if (retrievedContact.LastName == 'Thornie') {
                contactIdMap.put('Thornie', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Hudson') {
                contactIdMap.put('Hudson', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Booz') {
                contactIdMap.put('Booz', retrievedContact.Id);
            } else if (retrievedContact.LastName == 'Bear') {
                contactIdMap.put('Bear', retrievedContact.Id);
            }
        }

        return contactIdMap;
    }

    private static Map<String, Id> getJobApplicationIdMap() {
        List<Job_Application__c> retrievedJobApplications = [
            SELECT 
                Id, 
                Position_Title__c 
            FROM Job_Application__c 
            WHERE Position_Title__c IN :POSITION_TITLES 
            WITH USER_MODE
        ];

        Map<String, Id> jobApplicationIdMap = new Map<String, Id>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplications) {
            if (retrievedJobApplication.Position_Title__c == 'jobApplicationBlackthorn') {
                jobApplicationIdMap.put('jobApplicationBlackthorn', retrievedJobApplication.Id);
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationHTS') {
                jobApplicationIdMap.put('jobApplicationHTS', retrievedJobApplication.Id);
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationBAH') {
                jobApplicationIdMap.put('jobApplicationBAH', retrievedJobApplication.Id);
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationSalesforce') {
                jobApplicationIdMap.put('jobApplicationSalesforce', retrievedJobApplication.Id);
            }
        }

        return jobApplicationIdMap;
    }

    @IsTest
    private static void update_job_application_primary_contact_on_update() {
        // GIVEN
        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        Map<String, Id> jobApplicationIdMap = getJobApplicationIdMap();

        Id jobApplicationBlackthornId = jobApplicationIdMap.get('jobApplicationBlackthorn');
        Id jobApplicationHTSId = jobApplicationIdMap.get('jobApplicationHTS');
        Id jobApplicationBAHId = jobApplicationIdMap.get('jobApplicationBAH');
        Id jobApplicationSalesforceId = jobApplicationIdMap.get('jobApplicationSalesforce');

        List<Job_Application_Contact__c> jobApplicationContacts = testDataFactory.createJobApplicationContacts_setPrimaryContact_JobApplicationContactTest(
            contactBoozId, 
            contactBearId, 
            jobApplicationBlackthornId, 
            jobApplicationHTSId, 
            jobApplicationBAHId, 
            jobApplicationSalesforceId
        );

        if (Schema.sObjectType.Job_Application_Contact__c.isCreateable()) {
            insert as user jobApplicationContacts;
        }


        for (Job_Application_Contact__c jobApplicationContact : jobApplicationContacts) {
            jobApplicationContact.Contact__c = null;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationContacts;
        }

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Position_Title__c IN :POSITION_TITLES 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            jobApplicationToUpdate.Primary_Contact__c = null;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application_Contact__c jobApplicationContact : jobApplicationContacts) {
            if (jobApplicationContact.Job_Application__c == jobApplicationBlackthornId) {
                jobApplicationContact.Contact__c = contactThornieId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationHTSId) {
                jobApplicationContact.Contact__c = contactHudsonId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationBAHId) {
                jobApplicationContact.Contact__c = contactBoozId;
            } else if (jobApplicationContact.Job_Application__c == jobApplicationSalesforceId) {
                jobApplicationContact.Contact__c = contactBearId;
            } else {
                jobApplicationContact.Contact__c = null;
            }
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationContacts;
        }

        Test.stopTest();

        // THEN
        List<Job_Application__c> retrievedJobApplications = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Position_Title__c IN :POSITION_TITLES 
            WITH USER_MODE
        ];

        List<Job_Application__c> retrievedJobApplications_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplications_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplications) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplications_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplications_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplications_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplications_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(1, retrievedJobApplications_Thornie.size(), 'Expect 1 job application with Thornie as primary contact');
        System.assertEquals(1, retrievedJobApplications_Hudson.size(), 'Expect 1 job application with Hudson as primary contact');
        System.assertEquals(1, retrievedJobApplications_Booz.size(), 'Expect 1 job application with Booz as primary contact');
        System.assertEquals(1, retrievedJobApplications_Bear.size(), 'Expect 1 job application with Bear as primary contact');
    }
}