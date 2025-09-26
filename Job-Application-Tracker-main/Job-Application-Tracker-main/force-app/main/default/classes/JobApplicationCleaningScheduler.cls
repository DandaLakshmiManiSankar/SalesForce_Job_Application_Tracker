public with sharing class JobApplicationCleaningScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        JobApplicationCleaningQueueable queueableJob = new JobApplicationCleaningQueueable();

        Id jobId = System.enqueueJob(queueableJob);

        AsyncApexJob jobInfo = [
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
    }
}