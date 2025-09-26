@IsTest
private with sharing class JobControllerTest {
    @TestSetup
    private static void setup() {
        List<Job__c> jobsToInsert = new TestDataFactory().createJobs_setup_JobControllerTest();

        if (Schema.sObjectType.Job__c.isCreateable()) {
            insert as user jobsToInsert;
        }
    }

    @IsTest
    private static void retrieve_three_jobs() {
        // GIVEN

        // WHEN
        Test.startTest();

        List<Job__c> retrievedJobs = JobController.queryJobs();

        Test.stopTest();

        // THEN
        System.assertEquals(3, retrievedJobs.size(), 'Expect 3 retrieved jobs');
    }

    @IsTest
    private static void delete_jobs() {
        // GIVEN
        List<Job__c> jobs = JobController.queryJobs();

        List<String> recordIds = new List<String>();

        for (Job__c job : jobs) {
            recordIds.add(job.Id);
        }

        // WHEN
        Test.startTest();

        JobController.deleteJobs(recordIds);

        Test.stopTest();

        // THEN
        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedJobs.size(), 'Expect 0 jobs after deletion');
    }

    @IsTest
    private static void delete_all_jobs() {
        // GIVEN

        // WHEN
        Test.startTest();

        JobController.deleteAllJobs();

        Test.stopTest();

        // THEN
        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedJobs.size(), 'Expect 0 jobs after deletion');
    }
}