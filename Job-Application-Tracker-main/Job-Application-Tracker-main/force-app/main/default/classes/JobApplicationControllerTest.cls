@IsTest
private with sharing class JobApplicationControllerTest {
    @TestSetup
    private static void setup() {
        TestDataFactory testDataFactory = new TestDataFactory();

        List<Job__c> jobsToInsert = testDataFactory.createJobs_setup_JobApplicationControllerTest();

        if (Schema.sObjectType.Job__c.isCreateable()) {
            insert as user jobsToInsert;
        }

        Job__c jobJrSFDev;
        Job__c jobSFDev;

        for (Job__c jobToInsert : jobsToInsert) {
            if (jobToInsert.Title__c == 'Junior Salesforce Developer') {
                jobJrSFDev = jobToInsert;
            } else if (jobToInsert.Title__c == 'Salesforce Developer') {
                jobSFDev = jobToInsert;
            }
        }

        List<Account> acctsToInsert = testDataFactory.createAccts_setup_JobApplicationControllerTest();

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user acctsToInsert;
        }

        Id accCodeEveryDayId;
        Id accSalesforceId;

        for (Account accToInsert : acctsToInsert) {
            if (accToInsert.Name == 'CodeEveryDay') {
                accCodeEveryDayId = accToInsert.Id;
            } else if (accToInsert.Name == 'Salesforce') {
                accSalesforceId = accToInsert.Id;
            }
        }

        List<Job_Application__c> jobApplicationsToInsert = testDataFactory.createJobApplications_setup_JobApplicationControllerTest(
            jobJrSFDev, 
            accCodeEveryDayId, 
            jobSFDev, 
            accSalesforceId
        );

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }
    }

    @IsTest
    private static void upsert_job_applications_results_in_four_accounts_and_three_job_applications_with_Saved_status() {
        // GIVEN
        List<Job__c> jobs = [
            SELECT Id 
            FROM Job__c 
            WITH USER_MODE
        ];

        List<String> recordIds = new List<String>();

        for (Job__c job : jobs) {
            recordIds.add(job.Id);
        }

        // WHEN
        Test.startTest();

        JobApplicationController.upsertJobApplications(recordIds);

        Test.stopTest();

        // THEN
        List<Account> retrievedAccts = [
            SELECT Id 
            FROM Account 
            WITH USER_MODE
        ];

        System.assertEquals(4, retrievedAccts.size(), 'Expect 4 accounts');

        final String SAVED = 'Saved';

        List<Job_Application__c> retrievedJobApplications = [
            SELECT Id 
            FROM Job_Application__c 
            WHERE Status__c = :SAVED 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedJobApplications.size(), 'Expect 3 job applications with Saved status');
    }
}