final String CRON_EXP = '0 0 7 * * ?';

EventReminderScheduler job = new EventReminderScheduler();

String jobId = System.schedule('EventReminderSchedulerJob', CRON_EXP, job);

System.debug('jobId = ' + jobId);

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

System.debug('cronTrigger = ' + cronTrigger);