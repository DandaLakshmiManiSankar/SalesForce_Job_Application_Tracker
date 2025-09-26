final String CRON_EXP = '0 0 1 * * ?';

JobApplicationCleaningScheduler job = new JobApplicationCleaningScheduler();

String jobId = System.schedule('JobApplicationCleaningSchedulerJob', CRON_EXP, job);

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