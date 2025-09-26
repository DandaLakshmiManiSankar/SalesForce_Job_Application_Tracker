@IsTest
private with sharing class JobApplicationCleaningSchedulerTest {
    @IsTest
    private static void schedule_job_at_one() {
        // GIVEN
        final String CRON_EXP = '0 0 1 * * ?';

        JobApplicationCleaningScheduler job = new JobApplicationCleaningScheduler();

        // WHEN
        Test.startTest();

        String jobId = System.schedule('JobApplicationCleaningSchedulerJob', CRON_EXP, job);

        Test.stopTest();

        // THEN
        Datetime now = Datetime.now();
        Datetime nextFireTime;

        if (now.hour() < 1) {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day(), 1, 0, 0);
        } else {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day() + 1, 1, 0, 0);
        }

        CronTrigger cronTrigger = [
            SELECT 
                Id, 
                NextFireTime, 
                State, 
                TimesTriggered 
            FROM CronTrigger 
            WHERE Id = :jobId 
            WITH USER_MODE 
            LIMIT 1
        ];

        System.assertEquals(String.valueOf(nextFireTime), String.valueOf(cronTrigger.NextFireTime), 'Expect NextFireTime to be 1:00 AM');
        System.assertEquals('WAITING', cronTrigger.State, 'Expect State to be WAITING');
        System.assertEquals(0, cronTrigger.TimesTriggered, 'Expect TimesTriggered to be 0');
    }
}