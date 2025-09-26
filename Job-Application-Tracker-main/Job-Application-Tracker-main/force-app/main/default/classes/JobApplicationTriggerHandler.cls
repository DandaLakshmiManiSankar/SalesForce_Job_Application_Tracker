public with sharing class JobApplicationTriggerHandler {
    public void validateApplicationAndFollowUpDate(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Application_Date__c > newJobApplication.Follow_Up_Date__c) {
                final String ERROR = 'Application Date cannot be after Follow-Up Date';

                newJobApplication.addError(ERROR);
            }
        }
    }

    public void createTask_Insert(List<Job_Application__c> triggerDotNew) {
        List<Task> tasksToInsert = new List<Task>();

        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Status__c != null) {
                tasksToInsert.add(createTask(newJobApplication));
            }
        }

        if (Schema.sObjectType.Task.isCreateable()) {
            insert as user tasksToInsert;
        }
    }

    private Task createTask(Job_Application__c jobApplication) {
        String status = jobApplication.Status__c;

        Id jobApplicationId = jobApplication.Id;
        Id jobApplicationPrimaryContact = jobApplication.Primary_Contact__c;
        Id jobApplicationOwnerId = jobApplication.OwnerId;

        Task task = new Task();

        switch on status {
            when 'Saved' {
                task.Subject = 'Things to do for a job saved';
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Low';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Applying' {
                task.Subject = 'Things to do for a job to apply';
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Applied' {
                task.Subject = 'Things to do after applying for a job';
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Interviewing' {
                task.Subject = 'Interview prep';
                task.ActivityDate = Date.today().addDays(1);
                task.Priority = 'High';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Negotiating' {
                task.Subject = 'Negotiation prep';
                task.ActivityDate = Date.today().addDays(1);
                task.Priority = 'High';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Accepted' {
                task.Subject = 'Celebration';
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Low';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }

            when 'Closed' {
                task.Subject = 'Closed job application';
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
                task.Description = getDescription(status);
                task.WhatId = jobApplicationId;
                task.WhoId = jobApplicationPrimaryContact;
                task.OwnerId = jobApplicationOwnerId;
            }
        }

        return task;
    }

    private String getDescription(String status) {
        final String DESCRIPTION;

        switch on status {
            when 'Saved' {
                DESCRIPTION = 
                    '• Check if the job description aligns with your interests and values\n' 
                    + '• Review the highlighted skills to see if the role is a good fit\n' 
                    + '• Research the company or role and mark your excitement level'
                ;
            }

            when 'Applying' {
                DESCRIPTION = 
                    '• Find and research someone who works at the company and add them as a contact\n' 
                    + '• Set up an informational interview to learn more about the role/company\n' 
                    + '• Identify potential referrals to help get your application on the top of the pile\n' 
                    + '• Customize your work achievements using the job description keywords\n' 
                    + '• Submit your application on the company website if possible'
                ;
            }

            when 'Applied' {
                DESCRIPTION = 
                    '• Reach out to the hiring manager or recruiter\n' 
                    + '• Follow up on your application via email weekly\n' 
                    + '• Continue identifying and saving similar job opportunities\n' 
                    + '• Set up weekly networking calls to explore similar companies/roles'
                ;
            }

            when 'Interviewing' {
                DESCRIPTION = 
                    '• Prepare your blurb or "tell me about yourself" response\n' 
                    + '• Practice answering behavioral interview questions\n' 
                    + '• Research the company and your interviewers\n' 
                    + '• Set up your virtual interview space and test your tech\n' 
                    + '• Send thank you emails within 24 hours'
                ;
            }

            when 'Negotiating' {
                DESCRIPTION = 
                    '• Research your market value and know your numbers\n' 
                    + '• Prepare your negotiation scripts\n' 
                    + '• Evaluate your offer and decline or accept'
                ;
            }

            when 'Accepted' {
                DESCRIPTION = 
                    '• Plan your resignation if applicable\n' 
                    + '• Take some time to relax and recharge\n' 
                    + '• Prepare for your first day of onboarding'
                ;
            }

            when 'Closed' {
                DESCRIPTION = 
                    '• Send a follow-up email thanking the interviewer and asking for feedback\n' 
                    + '• Review your notes and reflect on areas of improvement'
                ;
            }
        }

        return DESCRIPTION;
    }

    public void createTask_Update(Map<Id, Job_Application__c> triggerDotOldMap, List<Job_Application__c> triggerDotNew) {
        List<Task> tasksToInsert = new List<Task>();

        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (
                triggerDotOldMap.get(newJobApplication.Id).Status__c != newJobApplication.Status__c 
                && newJobApplication.Status__c != null
            ) {
                tasksToInsert.add(createTask(newJobApplication));
            }
        }

        if (Schema.sObjectType.Task.isCreateable()) {
            insert as user tasksToInsert;
        }
    }

    public void setPrimaryContact(List<Job_Application__c> triggerDotNew) {
        for (Job_Application__c newJobApplication : triggerDotNew) {
            if (newJobApplication.Primary_Contact__c == null) {
                Id primaryContactId = getPrimaryContact(newJobApplication);

                if (primaryContactId != null) {
                    newJobApplication.Primary_Contact__c = primaryContactId;
                }
            }
        }
    }

    private Id getPrimaryContact(Job_Application__c newJobApplication) {
        List<Job_Application_Contact__c> retrievedJobApplicationContacts = [
            SELECT Contact__c 
            FROM Job_Application_Contact__c 
            WHERE Job_Application__c = :newJobApplication.Id 
            WITH USER_MODE 
            ORDER BY SystemModStamp ASC 
            LIMIT 1
        ];

        Id primaryContactId;

        if (!retrievedJobApplicationContacts.isEmpty()) {
            for (Job_Application_Contact__c retrievedJobApplicationContact : retrievedJobApplicationContacts) {
                primaryContactId = retrievedJobApplicationContact.Contact__c;
            }
        }

        if (
            primaryContactId == null 
            && newJobApplication.Company__c != null
        ) {
            List<Contact> retrievedContacts = [
                SELECT Id 
                FROM Contact 
                WHERE AccountId = :newJobApplication.Company__c 
                WITH USER_MODE 
                ORDER BY SystemModStamp ASC 
                LIMIT 1
            ];

            if (!retrievedContacts.isEmpty()) {
                for (Contact retrievedContact : retrievedContacts) {
                    primaryContactId = retrievedContact.Id;
                }
            }
        }

        return primaryContactId;
    }
}