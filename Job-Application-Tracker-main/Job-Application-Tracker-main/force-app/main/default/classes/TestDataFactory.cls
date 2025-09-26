public with sharing class TestDataFactory {
    @TestVisible
    private List<Account> createAccts_setup_JobApplicationTest_JobApplicationContactTest() {
        List<Account> accts = new List<Account>();

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        accts.add(accBlackthorn);

        Account accHTS = new Account(Name = 'Hudson Technology Systems');

        accts.add(accHTS);

        Account accBAH = new Account(Name = 'Booz Allen Hamilton');

        accts.add(accBAH);

        Account accSalesforce = new Account(Name = 'Salesforce');

        accts.add(accSalesforce);

        return accts;
    }

    @TestVisible
    private List<Contact> createContacts_setup_JobApplicationTest_JobApplicationContactTest() {
        List<Contact> contacts = new List<Contact>();

        Contact contactThornie = new Contact(LastName = 'Thornie');

        contacts.add(contactThornie);

        Contact contactHudson = new Contact(LastName = 'Hudson');

        contacts.add(contactHudson);

        Contact contactBooz = new Contact(LastName = 'Booz');

        contacts.add(contactBooz);

        Contact contactBear = new Contact(LastName = 'Bear');

        contacts.add(contactBear);

        return contacts;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setup_JobApplicationTest(
        Id accBlackthornId, 
        Id contactThornieId, 
        Id accHTSId, 
        Id contactHudsonId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBlackthorn = createJobApplication(
            null, 
            'jobApplicationBlackthorn', 
            accBlackthornId, 
            contactThornieId
        );

        jobApplications.add(jobApplicationBlackthorn);

        Job_Application__c jobApplicationHTS = createJobApplication(
            'Closed', 
            'jobApplicationHTS', 
            accHTSId, 
            contactHudsonId
        );

        jobApplications.add(jobApplicationHTS);

        return jobApplications;
    }

    private Job_Application__c createJobApplication(
        String status, 
        String position_title, 
        Id accId, 
        Id contactId
    ) {
        Job_Application__c jobApplication = new Job_Application__c(
            Status__c = status, 
            Rating__c = '3 Star', 
            Notes__c = 'Notes', 
            Position_Title__c = position_title, 
            Work_Model__c = 'Remote', 
            Job_Type__c = 'Temporary', 
            Salary__c = 50000, 
            URL__c = 'https://trailhead.salesforce.com/en/career-path', 
            Job_Description__c = 'Description', 
            Company__c = accId, 
            Primary_Contact__c = contactId
        );

        return jobApplication;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Saved(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Saved', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Applying(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Applying', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Applied(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Applied', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Interviewing(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Interviewing', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Negotiating(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Negotiating', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Accepted(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Accepted', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_createTask_Closed(
        Id accBAHId, 
        Id contactBoozId, 
        Id accSalesforceId, 
        Id contactBearId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBAH = createJobApplication(
            'Closed', 
            'jobApplicationBAH', 
            accBAHId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            contactBearId
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setPrimaryContact_JobApplicationTest(
        Id accBlackthornId, 
        Id accHTSId, 
        Id contactBoozId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz', 
            accBlackthornId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz', 
            accBlackthornId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationBlackthorn_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact', 
            accBlackthornId, 
            null
        );

        jobApplications.add(jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact', 
            accBlackthornId, 
            null
        );

        jobApplications.add(jobApplicationBlackthorn_NoJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz', 
            accHTSId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz', 
            accHTSId, 
            contactBoozId
        );

        jobApplications.add(jobApplicationHTS_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact', 
            accHTSId, 
            null
        );

        jobApplications.add(jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact', 
            accHTSId, 
            null
        );

        jobApplications.add(jobApplicationHTS_NoJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz', 
            null, 
            contactBoozId
        );

        jobApplications.add(jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz = createJobApplication(
            null, 
            'jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz', 
            null, 
            contactBoozId
        );

        jobApplications.add(jobApplicationNoAcc_NoJobApplicationContacts_PrimaryContactBooz);

        Job_Application__c jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact', 
            null, 
            null
        );

        jobApplications.add(jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContact);

        Job_Application__c jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact = createJobApplication(
            null, 
            'jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact', 
            null, 
            null
        );

        jobApplications.add(jobApplicationNoAcc_NoJobApplicationContacts_NoPrimaryContact);

        return jobApplications;

        // 12 job applications
            // acc = Blackthorn | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Blackthorn | no contact related list | primary contact = Booz
            // acc = Blackthorn | contact related list = Hudson, Bear | no primary contact
            // acc = Blackthorn | no contact related list | no primary contact

            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | primary contact = Booz
            // acc = Hudson Technology Systems | no contact related list | primary contact = Booz
            // acc = Hudson Technology Systems | contact related list = Hudson, Bear | no primary contact
            // acc = Hudson Technology Systems | no contact related list | no primary contact

            // no acc | contact related list = Hudson, Bear | primary contact = Booz
            // no acc | no contact related list | primary contact = Booz
            // no acc | contact related list = Hudson, Bear | no primary contact
            // no acc | no contact related list | no primary contact
    }

    @TestVisible
    private List<Job_Application_Contact__c> createJobApplicationContacts_setPrimaryContact_JobApplicationTest(
        Id contactHudsonId, 
        Id contactBearId, 
        Id jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId, 
        Id jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId, 
        Id jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId, 
        Id jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
    ) {
        List<Job_Application_Contact__c> jobApplicationContacts = new List<Job_Application_Contact__c>();

        Job_Application_Contact__c jobApplicationContactBlackthorn_Hudson_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Hudson_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Hudson_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Hudson_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthorn_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_Hudson_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Hudson_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_Hudson_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Hudson_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTS_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactHTS_NoAcc_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_NoAcc_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactNoAcc_Bear_PrimaryContactBooz = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_PrimaryContactBoozId
        );

        jobApplicationContacts.add(jobApplicationContactNoAcc_Bear_PrimaryContactBooz);

        Job_Application_Contact__c jobApplicationContactHTS_NoAcc_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactHudsonId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_NoAcc_NoPrimaryContact);

        Job_Application_Contact__c jobApplicationContactNoAcc_Bear_NoPrimaryContact = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationNoAcc_HasJobApplicationContacts_NoPrimaryContactId
        );

        jobApplicationContacts.add(jobApplicationContactNoAcc_Bear_NoPrimaryContact);

        return jobApplicationContacts;

        // 12 job application contacts
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setup_JobApplicationContactTest(
        Id accBlackthornId, 
        Id contactThornieId, 
        Id accHTSId, 
        Id contactHudsonId, 
        Id accBAHId, 
        Id accSalesforceId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationBlackthorn = createJobApplication(
            null, 
            'jobApplicationBlackthorn', 
            accBlackthornId, 
            contactThornieId
        );

        jobApplications.add(jobApplicationBlackthorn);

        Job_Application__c jobApplicationHTS = createJobApplication(
            'Closed', 
            'jobApplicationHTS', 
            accHTSId, 
            contactHudsonId
        );

        jobApplications.add(jobApplicationHTS);

        Job_Application__c jobApplicationBAH = createJobApplication(
            null, 
            'jobApplicationBAH', 
            accBAHId, 
            null
        );

        jobApplications.add(jobApplicationBAH);

        Job_Application__c jobApplicationSalesforce = createJobApplication(
            null, 
            'jobApplicationSalesforce', 
            accSalesforceId, 
            null
        );

        jobApplications.add(jobApplicationSalesforce);

        return jobApplications;
    }

    @TestVisible
    private List<Job_Application_Contact__c> createJobApplicationContacts_setPrimaryContact_JobApplicationContactTest(
        Id contactBoozId, 
        Id contactBearId, 
        Id jobApplicationBlackthornId, 
        Id jobApplicationHTSId, 
        Id jobApplicationBAHId, 
        Id jobApplicationSalesforceId
    ) {
        List<Job_Application_Contact__c> jobApplicationContacts = new List<Job_Application_Contact__c>();

        Job_Application_Contact__c jobApplicationContactBlackthorn_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationBlackthornId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Booz);

        Job_Application_Contact__c jobApplicationContactBlackthorn_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBlackthornId
        );

        jobApplicationContacts.add(jobApplicationContactBlackthorn_Bear);

        Job_Application_Contact__c jobApplicationContactHTS_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationHTSId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Booz);

        Job_Application_Contact__c jobApplicationContactHTS_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationHTSId
        );

        jobApplicationContacts.add(jobApplicationContactHTS_Bear);

        Job_Application_Contact__c jobApplicationContactBAH_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationBAHId
        );

        jobApplicationContacts.add(jobApplicationContactBAH_Booz);

        Job_Application_Contact__c jobApplicationContactBAH_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationBAHId
        );

        jobApplicationContacts.add(jobApplicationContactBAH_Bear);

        Job_Application_Contact__c jobApplicationContactSalesforce_Bear = new Job_Application_Contact__c(
            Contact__c = contactBearId, 
            Job_Application__c = jobApplicationSalesforceId
        );

        jobApplicationContacts.add(jobApplicationContactSalesforce_Bear);

        Job_Application_Contact__c jobApplicationContactSalesforce_Booz = new Job_Application_Contact__c(
            Contact__c = contactBoozId, 
            Job_Application__c = jobApplicationSalesforceId
        );

        jobApplicationContacts.add(jobApplicationContactSalesforce_Booz);

        return jobApplicationContacts;

        // 8 job application contacts
    }

    @TestVisible
    private List<Job__c> createJobs_setup_JobControllerTest() {
        List<Job__c> jobs = new List<Job__c>();

        Job__c jobJrSFDev = new Job__c(
            Title__c = 'Junior Salesforce Developer', 
            Location__c = 'New York, NY', 
            Snippet__c = 'No actual work experience—no problem. Apply if you got the skills to do the work.', 
            Salary__c = '$3,210 per week', 
            Source__c = 'nowhere.com', 
            Type__c = 'Full-time', 
            Link__c = 'https://careers.codeeveryday.com/en/jobs', 
            Company__c = 'CodeEveryDay', 
            Id__c = '-1234567890123456789'
        );

        jobs.add(jobJrSFDev);

        Job__c jobSFDev = new Job__c(
            Title__c = 'Salesforce Developer', 
            Location__c = 'Jacksonville, FL', 
            Snippet__c = '', 
            Salary__c = '$90.1 - $95.9 per hour', 
            Source__c = 'somewhere.com', 
            Type__c = 'Part-time', 
            Link__c = 'https://careers.salesforce.com/en/jobs', 
            Company__c = 'Salesforce', 
            Id__c = '-2885668755075351000'
        );

        jobs.add(jobSFDev);

        Job__c jobSrSFDev = new Job__c(
            Title__c = 'Sr Salesforce Developer', 
            Location__c = 'Tampa, FL', 
            Snippet__c = '...POSITION Sr Salesforce Developer LOCATION Tampa FL Hybrid DURATION 6 months INTERVIEW TYPE Video REQUIRED SKILLS Financial Services experience highly preferred Needs a background in other programming...', 
            Salary__c = '$90.25k - $100.75k', 
            Source__c = 'drjobs.ae', 
            Type__c = 'Temporary', 
            Link__c = 'https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001', 
            Company__c = 'Hirekeyz Inc', 
            Id__c = '6407669124240903000'
        );

        jobs.add(jobSrSFDev);

        return jobs;
    }

    @TestVisible
    private List<Job__c> createJobs_setup_JobApplicationControllerTest() {
        List<Job__c> jobs = new List<Job__c>();

        Job__c jobJrSFDev = new Job__c(
            Title__c = 'Junior Salesforce Developer', 
            Location__c = 'Brooklyn, NY', 
            Snippet__c = '...No actual work experience No problem Apply if you got the skills to do the work...', 
            Salary__c = '$3,210 per week', 
            Source__c = 'nowhere.com', 
            Type__c = 'Full-time', 
            Link__c = 'https://careers.codeeveryday.com/en/jobs', 
            Company__c = 'CodeEveryDay', 
            Updated__c = Datetime.now() - 30, 
            Id__c = '-1234567890123456789'
        );

        jobs.add(jobJrSFDev);

        Job__c jobSFDev = new Job__c(
            Title__c = 'Salesforce Developer', 
            Location__c = 'New York, NY', 
            Snippet__c = '', 
            Salary__c = '$90.1 - $95.9 per hour', 
            Source__c = '', 
            Type__c = 'Temporary', 
            Link__c = 'https://careers.salesforce.com/en/jobs', 
            Company__c = 'Salesforce', 
            Id__c = '-2885668755075351000'
        );

        jobs.add(jobSFDev);

        Job__c jobTempSFDev = new Job__c(
            Title__c = 'Temporary Salesforce Developer', 
            Location__c = 'Staten Island, NY', 
            Snippet__c = '', 
            Salary__c = '', 
            Source__c = 'somewhere.com', 
            Type__c = 'Temporary', 
            Link__c = '', 
            Company__c = 'Temporary Devs', 
            Id__c = '-1234567890987654321'
        );

        jobs.add(jobTempSFDev);

        Job__c jobSrSFDev = new Job__c(
            Title__c = 'Sr Salesforce Developer', 
            Location__c = 'Queens, NY', 
            Snippet__c = '', 
            Salary__c = '', 
            Source__c = '', 
            Type__c = 'Temporary', 
            Link__c = 'https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001', 
            Company__c = 'Hirekeyz Inc', 
            Updated__c = Datetime.now() - 30, 
            Id__c = '6407669124240903000'
        );

        jobs.add(jobSrSFDev);

        return jobs;
    }

    @TestVisible
    private List<Account> createAccts_setup_JobApplicationControllerTest() {
        List<Account> accts = new List<Account>();

        Account accCodeEveryDay = new Account(Name = 'CodeEveryDay');

        accts.add(accCodeEveryDay);

        Account accSalesforce = new Account(Name = 'Salesforce');

        accts.add(accSalesforce);

        return accts;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setup_JobApplicationControllerTest(
        Job__c jobJrSFDev, 
        Id accCodeEveryDayId, 
        Job__c jobSFDev, 
        Id accSalesforceId
    ) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationJrSFDev = new Job_Application__c(
            Status__c = 'Interviewing', 
            Position_Title__c = jobJrSFDev.Title__c, 
            Company__c = accCodeEveryDayId, 
            Job_Id__c = jobJrSFDev.Id__c
        );

        jobApplications.add(jobApplicationJrSFDev);

        Job_Application__c jobApplicationSFDev = new Job_Application__c(
            Position_Title__c = jobSFDev.Title__c, 
            Company__c = accSalesforceId, 
            Job_Id__c = jobSFDev.Id__c
        );

        jobApplications.add(jobApplicationSFDev);

        return jobApplications;
    }

    @TestVisible
    private List<Event> createEvents_setup() {
        List<Event> events = new List<Event>();

        Event codeEveryDay = new Event(
            Subject = 'codeEveryDay', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 05, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00)
        );

        events.add(codeEveryDay);

        Event dangerousCommute = new Event(
            Subject = 'dangerousCommute', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 10, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 13, 00, 00)
        );

        events.add(dangerousCommute);

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 20, 00, 00)
        );

        events.add(informationalInterview);

        return events;
    }

    @TestVisible
    private List<Job_Application__c> createJobApplications_setup_JobApplicationCleaningQueueableTest() {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();

        Job_Application__c jobApplicationSavedFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Saved', 
            Follow_Up_Date__c = Date.today() - 29
        );

        jobApplications.add(jobApplicationSavedFollowUp29DaysAgo);

        Job_Application__c jobApplicationSavedFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Saved', 
            Follow_Up_Date__c = Date.today() - 30
        );

        jobApplications.add(jobApplicationSavedFollowUp30DaysAgo);

        Job_Application__c jobApplicationApplyingFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Applying', 
            Follow_Up_Date__c = Date.today() - 29, 
            Notes__c = 'test note'
        );

        jobApplications.add(jobApplicationApplyingFollowUp29DaysAgo);

        Job_Application__c jobApplicationApplyingFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Applying', 
            Follow_Up_Date__c = Date.today() - 30, 
            Notes__c = 'test note'
        );

        jobApplications.add(jobApplicationApplyingFollowUp30DaysAgo);

        Job_Application__c jobApplicationAcceptedFollowUp29DaysAgo = new Job_Application__c(
            Status__c = 'Accepted', 
            Follow_Up_Date__c = Date.today() - 29
        );

        jobApplications.add(jobApplicationAcceptedFollowUp29DaysAgo);

        Job_Application__c jobApplicationAcceptedFollowUp30DaysAgo = new Job_Application__c(
            Status__c = 'Accepted', 
            Follow_Up_Date__c = Date.today() - 30
        );

        jobApplications.add(jobApplicationAcceptedFollowUp30DaysAgo);

        return jobApplications;
    }
}