public with sharing class JobApplicationController {
    @AuraEnabled
    public static void upsertJobApplications(List<String> recordIds) {
        List<Job_Application__c> jobApplicationsToUpsert = createJobApplicationsFromJobs(recordIds);

        setStatusToSavedForJobApplicationsWithoutStatus(jobApplicationsToUpsert);

        if (Schema.sObjectType.Job_Application__c.isCreateable() && Schema.sObjectType.Job_Application__c.isUpdateable()) {
            upsert as user jobApplicationsToUpsert Job_Id__c;
        }
    }

    private static List<Job_Application__c> createJobApplicationsFromJobs(List<String> recordIds) {
        List<Job__c> jobs = [
            SELECT 
                Id, 
                Title__c, 
                Location__c, 
                Snippet__c, 
                Salary__c, 
                Source__c, 
                Type__c, 
                Link__c, 
                Company__c, 
                Updated__c, 
                Id__c 
            FROM Job__c 
            WHERE Id IN :recordIds 
            WITH USER_MODE
        ];

        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        for (Job__c job : jobs) {
            Job_Application__c jobApplication = new Job_Application__c();

            if (!String.isBlank(job.Title__c)) {
                jobApplication.Position_Title__c = job.Title__c;
            }

            if (!String.isBlank(job.Location__c)) {
                jobApplication.Location__c = job.Location__c;
            }

            if (!String.isBlank(job.Snippet__c)) {
                jobApplication.Job_Description__c = job.Snippet__c;
            }

            if (!String.isBlank(job.Salary__c)) {
                try {
                    jobApplication.Salary__c = Decimal.valueOf(job.Salary__c);
                } catch (TypeException e) {
                    final String SALARY_TO_JOB_DESCRIPTION = '\n\nSalary: ' + job.Salary__c;

                    if (String.isBlank(jobApplication.Job_Description__c)) {
                        jobApplication.Job_Description__c = SALARY_TO_JOB_DESCRIPTION.trim();
                    } else {
                        jobApplication.Job_Description__c += SALARY_TO_JOB_DESCRIPTION;
                    }
                }
            }

            if (!String.isBlank(job.Source__c)) {
                final String SOURCE_TO_JOB_DESCRIPTION = '\n\nSource: ' + job.Source__c;

                if (String.isBlank(jobApplication.Job_Description__c)) {
                    jobApplication.Job_Description__c = SOURCE_TO_JOB_DESCRIPTION.trim();
                } else {
                    jobApplication.Job_Description__c += SOURCE_TO_JOB_DESCRIPTION;
                }
            }

            if (
                !String.isBlank(job.Type__c) 
                && (job.Type__c == 'Full-time' || job.Type__c == 'Temporary')
            ) {
                jobApplication.Job_Type__c = job.Type__c;
            }

            if (!String.isBlank(job.Link__c)) {
                jobApplication.URL__c = job.Link__c;
            }

            if (!String.isBlank(job.Company__c)) {
                jobApplication.Company__c = getAccId(job.Company__c);
            }

            if (!String.isBlank(String.valueOf(job.Updated__c))) {
                final String DATE_UPDATED_TO_JOB_DESCRIPTION = '\n\nUpdated: ' + String.valueOf(job.Updated__c);

                if (String.isBlank(jobApplication.Job_Description__c)) {
                    jobApplication.Job_Description__c = DATE_UPDATED_TO_JOB_DESCRIPTION.trim();
                } else {
                    jobApplication.Job_Description__c += DATE_UPDATED_TO_JOB_DESCRIPTION;
                }
            }

            if (!String.isBlank(job.Id__c)) {
                jobApplication.Job_Id__c = job.Id__c;
            }

            jobApplications.add(jobApplication);
        }

        return jobApplications;
    }

    private static String getAccId(String company) {
        String accId;

        if (company != null) {
            List<Account> retrievedAccts = [
                SELECT 
                    Id, 
                    Name 
                FROM Account 
                WHERE Name = :company 
                WITH USER_MODE 
                LIMIT 1
            ];

            if (retrievedAccts.isEmpty()) {
                accId = createAcc(company);
            } else {
                accId = retrievedAccts[0].Id;
            }
        }

        return accId;
    }

    private static Id createAcc(String company) {
        Account accToInsert = new Account(Name = company);

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user accToInsert;
        }

        return accToInsert.Id;
    }

    private static void setStatusToSavedForJobApplicationsWithoutStatus(List<Job_Application__c> jobApplications) {
        Set<String> jobIds = new Set<String>();

        for (Job_Application__c jobApplication : jobApplications) {
            jobIds.add(jobApplication.Job_Id__c);
        }

        List<Job_Application__c> existingJobApplicationsWithStatus = [
            SELECT Job_Id__c 
            FROM Job_Application__c 
            WHERE Job_Id__c = :jobIds 
                AND Status__c != null 
            WITH USER_MODE
        ];

        Map<String, String> existingJobIdMap = new Map<String, String>();

        for (Job_Application__c existingJobApplicationWithStatus : existingJobApplicationsWithStatus) {
            existingJobIdMap.put(existingJobApplicationWithStatus.Job_Id__c, existingJobApplicationWithStatus.Job_Id__c);
        }

        for (Job_Application__c jobApplication : jobApplications) {
            if (!existingJobIdMap.containsKey(jobApplication.Job_Id__c)) {
                jobApplication.Status__c = 'Saved';
            }
        }
    }
}