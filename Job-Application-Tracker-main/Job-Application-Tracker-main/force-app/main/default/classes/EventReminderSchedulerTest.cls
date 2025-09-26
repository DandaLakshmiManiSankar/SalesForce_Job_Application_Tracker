@IsTest
private with sharing class EventReminderSchedulerTest {
    @IsTest
    private static void schedule_job_at_seven() {
        // GIVEN
        final String CRON_EXP = '0 0 7 * * ?';

        EventReminderScheduler job = new EventReminderScheduler();

        // WHEN
        Test.startTest();

        String jobId = System.schedule('EventReminderSchedulerJob', CRON_EXP, job);

        Test.stopTest();

        // THEN
        Datetime now = Datetime.now();
        Datetime nextFireTime;

        if (now.hour() < 7) {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day(), 7, 0, 0);
        } else {
            nextFireTime = Datetime.newInstance(now.year(), now.month(), now.day() + 1, 7, 0, 0);
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

        System.assertEquals(String.valueOf(nextFireTime), String.valueOf(cronTrigger.NextFireTime), 'Expect NextFireTime to be 7:00 AM');
        System.assertEquals('WAITING', cronTrigger.State, 'Expect State to be WAITING');
        System.assertEquals(0, cronTrigger.TimesTriggered, 'Expect TimesTriggered to be 0');
    }
}