@IsTest
private class JobApplicationCleaningQueueableTest {
    @TestSetup
    private static void setup() {
        List<Job_Application__c> jobApplicationsToInsert = new TestDataFactory().createJobApplications_setup_JobApplicationCleaningQueueableTest();

        if (Schema.sObjectType.Job_Application__c.isCreateable()) {
            insert as user jobApplicationsToInsert;
        }
    }

    @IsTest
    private static void update_two_job_applications_status_to_Closed() {
        // GIVEN

        // WHEN
        Test.startTest();

        Id jobId = System.enqueueJob(new JobApplicationCleaningQueueable());

        AsyncApexJob jobInfo_WHEN = [
            SELECT 
                Status, 
                TotalJobItems, 
                JobItemsProcessed, 
                NumberOfErrors 
            FROM AsyncApexJob 
            WHERE Id = :jobId 
            WITH USER_MODE 
            LIMIT 1
        ];

        System.assertEquals('Queued', jobInfo_WHEN.Status, 'Expect Status to be Queued');
        System.assertEquals(0, jobInfo_WHEN.TotalJobItems, 'Expect 0 TotalJobItems');
        System.assertEquals(0, jobInfo_WHEN.JobItemsProcessed, 'Expect 0 JobItemsProcessed');
        System.assertEquals(0, jobInfo_WHEN.NumberOfErrors, 'Expect 0 NumberOfErrors');

        Test.stopTest();

        // THEN
        final String CLOSED = 'Closed';

        List<Job_Application__c> retrievedJobApplications = [
            SELECT 
                Status__c, 
                Follow_Up_Date__c 
            FROM Job_Application__c 
            WHERE Status__c = :CLOSED 
                AND Follow_Up_Date__c != null 
                AND Follow_Up_Date__c <= N_DAYS_AGO:30 
            WITH USER_MODE
        ];

        System.assertEquals(2, retrievedJobApplications.size(), 'Expect 2 stale job applications with Closed status');

        AsyncApexJob jobInfo_THEN = [
            SELECT 
                Status, 
                TotalJobItems, 
                JobItemsProcessed, 
                NumberOfErrors 
            FROM AsyncApexJob 
            WHERE Id = :jobId 
            WITH USER_MODE 
            LIMIT 1
        ];

        System.assertEquals('Completed', jobInfo_THEN.Status, 'Expect Status to be Completed');
        System.assertEquals(0, jobInfo_THEN.TotalJobItems, 'Expect 0 TotalJobItems');
        System.assertEquals(0, jobInfo_THEN.JobItemsProcessed, 'Expect 0 JobItemsProcessed');
        System.assertEquals(0, jobInfo_THEN.NumberOfErrors, 'Expect 0 NumberOfErrors');
    }
}