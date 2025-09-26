@IsTest
private with sharing class JobApplicationTest {
    private static TestDataFactory testDataFactory = new TestDataFactory();

    private static final String LOW = 'Low';
    private static final String NORMAL = 'Normal';
    private static final String HIGH = 'High';

    @TestSetup
    private static void setup() {
        List<Account> acctsToInsert = testDataFactory.createAccts_setup_JobApplicationTest_JobApplicationContactTest();

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user acctsToInsert;
        }

        Id accBlackthornId;
        Id accHTSId;

        for (Account accToInsert : acctsToInsert) {
            if (accToInsert.Name == 'Blackthorn') {
                accBlackthornId = accToInsert.Id;
            } else if (accToInsert.Name == 'Hudson Technology Systems') {
                accHTSId = accToInsert.Id;
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

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_setup_JobApplicationTest(
            accBlackthornId, 
            contactThornieId, 
            accHTSId, 
            contactHudsonId
        );

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }
    }

    @IsTest
    private static void application_date_cannot_be_after_follow_up_date_on_insert() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBearId = contactIdMap.get('Bear');

        Job_Application__c jobApplicationSalesforce = new Job_Application__c(
            Application_Date__c = Date.today() + 1, 
            Follow_Up_Date__c = Date.today(), 
            Rating__c = '3 Star', 
            Notes__c = 'Notes', 
            Position_Title__c = 'Junior Salesforce Developer', 
            Work_Model__c = 'Onsite', 
            Location__c = 'San Francisco, CA', 
            Job_Type__c = 'Temporary', 
            Salary__c = 50000, 
            URL__c = 'https://careers.salesforce.com', 
            Job_Description__c = 'Description', 
            Company__c = accSalesforceId, 
            Primary_Contact__c = contactBearId
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Job_Application__c.isCreateable()) {
                insert as user jobApplicationSalesforce;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Application Date cannot be after Follow-Up Date', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
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

    @IsTest
    private static void application_date_cannot_be_after_follow_up_date_on_update() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBearId = contactIdMap.get('Bear');

        Job_Application__c jobApplicationSalesforce = new Job_Application__c(
            Rating__c = '3 Star', 
            Notes__c = 'Notes', 
            Position_Title__c = 'Junior Salesforce Developer', 
            Work_Model__c = 'Onsite', 
            Location__c = 'San Francisco, CA', 
            Job_Type__c = 'Temporary', 
            Salary__c = 50000, 
            URL__c = 'https://careers.salesforce.com', 
            Job_Description__c = 'Description', 
            Company__c = accSalesforceId, 
            Primary_Contact__c = contactBearId
        );

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationSalesforce;
        }

        jobApplicationSalesforce.Application_Date__c = Date.today() + 1;
        jobApplicationSalesforce.Follow_Up_Date__c = Date.today();

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
                update as user jobApplicationSalesforce;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Application Date cannot be after Follow-Up Date', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Saved() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Saved(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Saved';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String SAVED_SUBJECT = 'Things to do for a job saved';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :SAVED_SUBJECT 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = :LOW 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Applying() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Applying(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applying';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String APPLYING_SUBJECT = 'Things to do for a job to apply';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :APPLYING_SUBJECT 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = :NORMAL 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Applied() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Applied(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Applied';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String APPLIED_SUBJECT = 'Things to do after applying for a job';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :APPLIED_SUBJECT 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = :NORMAL 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Interviewing() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Interviewing(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Interviewing';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String INTERVIEWING_SUBJECT = 'Interview prep';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :INTERVIEWING_SUBJECT 
                AND ActivityDate = TOMORROW 
                AND Priority = :HIGH 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Negotiating() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Negotiating(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Negotiating';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String NEGOTIATING_SUBJECT = 'Negotiation prep';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :NEGOTIATING_SUBJECT 
                AND ActivityDate = TOMORROW 
                AND Priority = :HIGH 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_three_tasks_if_job_application_status_is_Accepted() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Accepted(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Accepted';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String ACCEPTED_SUBJECT = 'Celebration';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :ACCEPTED_SUBJECT 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = :LOW 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedTasks.size(), 'Expect 3 tasks created');
    }

    @IsTest
    private static void create_two_tasks_if_job_application_status_is_Closed() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');
        Id accBAHId = accIdMap.get('BAH');
        Id accSalesforceId = accIdMap.get('Salesforce');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_createTask_Closed(
            accBAHId, 
            contactBoozId, 
            accSalesforceId, 
            contactBearId
        );

        List<Job_Application__c> jobApplicationsToUpdate = [
            SELECT 
                Status__c, 
                Company__c 
            FROM Job_Application__c 
            WHERE Company__c IN (
                    :accBlackthornId, 
                    :accHTSId
                ) 
            WITH USER_MODE
        ];

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            } else if (jobApplicationToUpdate.Company__c == accHTSId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            }
        }

        if (Schema.sObjectType.Task.isDeletable()) {
            delete as user [SELECT Id FROM Task WITH USER_MODE];
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Notes__c = 'Update Notes';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        for (Job_Application__c jobApplicationToUpdate : jobApplicationsToUpdate) {
            if (jobApplicationToUpdate.Company__c == accBlackthornId) {
                jobApplicationToUpdate.Status__c = 'Closed';
            }
        }

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user jobApplicationsToUpdate;
        }

        Test.stopTest();

        // THEN
        final String CLOSED_SUBJECT = 'Closed job application';

        List<Task> retrievedTasks = [
            SELECT Id 
            FROM Task 
            WHERE Subject = :CLOSED_SUBJECT 
                AND ActivityDate = NEXT_WEEK 
                AND Priority = :NORMAL 
            WITH USER_MODE
        ];

        System.assertEquals(2, retrievedTasks.size(), 'Expect 2 tasks created');
    }

    @IsTest
    private static void update_job_application_primary_contact_if_one_account_has_a_related_contact_and_job_application_contact_does_not_exist() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Contact> contactsToUpdate = [
            SELECT 
                LastName, 
                AccountId 
            FROM Contact 
            WHERE Id = :contactThornieId 
            WITH USER_MODE 
            LIMIT 1
        ];

        for (Contact contactToUpdate : contactsToUpdate) {
            if (contactToUpdate.LastName == 'Thornie') {
                contactToUpdate.AccountId = accBlackthornId;
            }
        }

        if (Schema.sObjectType.Contact.isUpdateable()) {
            update as user contactsToUpdate;
        }

        // only Blackthorn account has a related contact

        List<Job_Application__c> jobApplications = testDataFactory.createJobApplications_setPrimaryContact_JobApplicationTest(
            accBlackthornId, 
            accHTSId, 
            contactBoozId
        );

        // 12 job applications
            // acc = Blackthorn | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Blackthorn | no contact related list | primary contact = Booz
            // acc = Blackthorn | contact related list = Hudson, Bear | no primary contact
            // acc = Blackthorn | no contact related list | no primary contact

            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Hudson Technology Systems | no contact related list | primary contact = Booz
            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | no primary contact
            // acc = Hudson Technology Systems | no contact related list | no primary contact

            // no acc | contact related list = Hudson, Bear | primary contact = Booz
            // no acc | no contact related list | primary contact = Booz
            // no acc | contact related list = Hudson, Bear | no primary contact
            // no acc | no contact related list | no primary contact

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplications;
        }

        // THEN
        List<Job_Application__c> retrievedJobApplications = [
            SELECT 
                Id, 
                Primary_Contact__c, 
                Position_Title__c 
            FROM Job_Application__c 
            WHERE Id IN :jobApplications 
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

        System.assertEquals(2, retrievedJobApplications_Thornie.size(), 'Expect 2 job applications with Thornie as primary contact');
        System.assertEquals(0, retrievedJobApplications_Hudson.size(), 'Expect 0 job application with Hudson as primary contact');
        System.assertEquals(6, retrievedJobApplications_Booz.size(), 'Expect 6 job applications with Booz as primary contact');
        System.assertEquals(0, retrievedJobApplications_Bear.size(), 'Expect 0 job application with Bear as primary contact');
    }

    @IsTest
    private static void update_job_application_primary_contact_if_one_account_has_a_related_contact_and_job_application_contact_exists() {
        // GIVEN
        Map<String, Id> accIdMap = getAccIdMap();

        Id accBlackthornId = accIdMap.get('Blackthorn');
        Id accHTSId = accIdMap.get('HTS');

        Map<String, Id> contactIdMap = getContactIdMap();

        Id contactThornieId = contactIdMap.get('Thornie');
        Id contactHudsonId = contactIdMap.get('Hudson');
        Id contactBoozId = contactIdMap.get('Booz');
        Id contactBearId = contactIdMap.get('Bear');

        List<Contact> contactsToUpdate = [
            SELECT 
                LastName, 
                AccountId 
            FROM Contact 
            WHERE Id = :contactThornieId 
            WITH USER_MODE 
            LIMIT 1
        ];

        for (Contact contactToUpdate : contactsToUpdate) {
            if (contactToUpdate.LastName == 'Thornie') {
                contactToUpdate.AccountId = accBlackthornId;
            }
        }

        if (Schema.sObjectType.Contact.isUpdateable()) {
            update as user contactsToUpdate;
        }

        // only Blackthorn account has a related contact

        List<Job_Application__c> jobApplications = testDataFactory.createJobApplications_setPrimaryContact_JobApplicationTest(
            accBlackthornId, 
            accHTSId, 
            contactBoozId
        );

        // 12 job applications
            // acc = Blackthorn | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Blackthorn | no contact related list | primary contact = Booz
            // acc = Blackthorn | contact related list = Hudson, Bear | no primary contact
            // acc = Blackthorn | no contact related list | no primary contact

            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Hudson Technology Systems | no contact related list | primary contact = Booz
            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | no primary contact
            // acc = Hudson Technology Systems | no contact related list | no primary contact

            // no acc | contact related list = Hudson, Bear | primary contact = Booz
            // no acc | no contact related list | primary contact = Booz
            // no acc | contact related list = Hudson, Bear | no primary contact
            // no acc | no contact related list | no primary contact

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplications;
        }

        List<Job_Application__c> retrievedJobApplicationsAfterInsert = [
            SELECT 
                Id, 
                Primary_Contact__c, 
                Position_Title__c 
            FROM Job_Application__c 
            WHERE Id IN :jobApplications 
            WITH USER_MODE
        ];

        Id jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId;
        Id jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId;
        Id jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId;
        Id jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId;

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterInsert) {
            if (retrievedJobApplication.Position_Title__c == 'jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz') {
                jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else if (retrievedJobApplication.Position_Title__c == 'jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact') {
                jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId = retrievedJobApplication.Id;

                retrievedJobApplication.Primary_Contact__c = null;
            } else {
                retrievedJobApplication.Primary_Contact__c = null;
            }
        }

        List<Job_Application_Contact__c> jobApplicationContacts = testDataFactory.createJobApplicationContacts_setPrimaryContact_JobApplicationTest(
            contactHudsonId, 
            contactBearId, 
            jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId, 
            jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId, 
            jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId, 
            jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        if (Schema.sObjectType.Job_Application_Contact__c.isCreateable()) {
            insert as user jobApplicationContacts;
        }

        // WHEN
        Test.startTest();

        if (Schema.sObjectType.Job_Application__c.isUpdateable()) {
            update as user retrievedJobApplicationsAfterInsert;
        }

        Test.stopTest();

        // THEN
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate = [
            SELECT Primary_Contact__c 
            FROM Job_Application__c 
            WHERE Id IN :retrievedJobApplicationsAfterInsert 
            WITH USER_MODE
        ];

        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Thornie = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Hudson = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Booz = new List<Job_Application__c>();
        List<Job_Application__c> retrievedJobApplicationsAfterUpdate_Bear = new List<Job_Application__c>();

        for (Job_Application__c retrievedJobApplication : retrievedJobApplicationsAfterUpdate) {
            if (retrievedJobApplication.Primary_Contact__c == contactThornieId) {
                retrievedJobApplicationsAfterUpdate_Thornie.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactHudsonId) {
                retrievedJobApplicationsAfterUpdate_Hudson.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBoozId) {
                retrievedJobApplicationsAfterUpdate_Booz.add(retrievedJobApplication);
            } else if (retrievedJobApplication.Primary_Contact__c == contactBearId) {
                retrievedJobApplicationsAfterUpdate_Bear.add(retrievedJobApplication);
            }
        }

        System.assertEquals(2, retrievedJobApplicationsAfterUpdate_Thornie.size(), 'Expect 2 job applications with Thornie as primary contact');
        System.assertEquals(6, retrievedJobApplicationsAfterUpdate_Hudson.size(), 'Expect 6 job applications with Hudson as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterUpdate_Booz.size(), 'Expect 0 job application with Booz as primary contact');
        System.assertEquals(0, retrievedJobApplicationsAfterUpdate_Bear.size(), 'Expect 0 job application with Bear as primary contact');
    }
}