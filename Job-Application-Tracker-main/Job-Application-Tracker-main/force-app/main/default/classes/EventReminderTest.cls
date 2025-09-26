@IsTest
private with sharing class EventReminderTest {
    private static EventReminder eventReminder = new EventReminder();

    @IsTest
    private static void send_one_email_reminder_on_Friday_for_one_event_on_Monday() {
        // GIVEN
        Date friday = Date.valueOf(eventReminder.now).toStartOfWeek() - 2;

        eventReminder.now = Datetime.valueOf(friday + ' 00:00:00');

        Datetime nextWeekDayBegin = (Datetime) eventReminder.getNextWeekDayOrDay(eventReminder.now, true);
        Datetime nextWeekDayEnd = nextWeekDayBegin + 1;

        Integer year = nextWeekDayBegin.year();
        Integer month = nextWeekDayBegin.month();
        Integer day = nextWeekDayBegin.day();

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user accBlackthorn;
        }

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        if (Schema.sObjectType.Contact.isCreateable()) {
            insert as user contactThornie;
        }

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'
        );

        if (Schema.sObjectType.Event.isCreateable()) {
            insert as user informationalInterview;
        }

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }

    @IsTest
    private static void send_one_email_reminder_on_Saturday_for_one_event_on_Monday() {
        // GIVEN
        Date saturday = Date.valueOf(eventReminder.now).toStartOfWeek() - 1;

        eventReminder.now = Datetime.valueOf(saturday + ' 00:00:00');

        Datetime nextWeekDayBegin = (Datetime) eventReminder.getNextWeekDayOrDay(eventReminder.now, true);
        Datetime nextWeekDayEnd = nextWeekDayBegin + 1;

        Integer year = nextWeekDayBegin.year();
        Integer month = nextWeekDayBegin.month();
        Integer day = nextWeekDayBegin.day();

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user accBlackthorn;
        }

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        if (Schema.sObjectType.Contact.isCreateable()) {
            insert as user contactThornie;
        }

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'
        );

        if (Schema.sObjectType.Event.isCreateable()) {
            insert as user informationalInterview;
        }

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }
    @IsTest
    private static void send_one_email_reminder_on_Sunday_for_one_event_on_Monday() {
        // GIVEN
        Date sunday = Date.valueOf(eventReminder.now).toStartOfWeek();

        eventReminder.now = Datetime.valueOf(sunday + ' 00:00:00');

        Datetime nextWeekDayBegin = (Datetime) eventReminder.getNextWeekDayOrDay(eventReminder.now, true);
        Datetime nextWeekDayEnd = nextWeekDayBegin + 1;

        Integer year = nextWeekDayBegin.year();
        Integer month = nextWeekDayBegin.month();
        Integer day = nextWeekDayBegin.day();

        Account accBlackthorn = new Account(Name = 'Blackthorn');

        if (Schema.sObjectType.Account.isCreateable()) {
            insert as user accBlackthorn;
        }

        Contact contactThornie = new Contact(LastName = 'Thornie', AccountId = accBlackthorn.Id);

        if (Schema.sObjectType.Contact.isCreateable()) {
            insert as user contactThornie;
        }

        Event informationalInterview = new Event(
            Subject = 'informationalInterview', 
            StartDateTime = Datetime.newInstance(year, month, day, 17, 00, 00), 
            EndDateTime = Datetime.newInstance(year, month, day, 20, 00, 00), 
            Location = 'no where', 
            WhoId = contactThornie.Id, 
            Type = 'Informational Interview', 
            Interview_Format__c = '1-on-1', 
            Description = 'Description'
        );

        if (Schema.sObjectType.Event.isCreateable()) {
            insert as user informationalInterview;
        }

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEvents.size(), 'Expect 1 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                TextBody, 
                Subject, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage 
            WITH USER_MODE
        ];

        System.assertEquals(1, retrievedEmailMessages.size(), 'Expect 1 email message');
    }

    @IsTest
    private static void send_zero_email_reminder() {
        // GIVEN

        // WHEN
        Test.startTest();

        eventReminder.emailReminderBeforeInterviewOnNextWeekDay();

        Test.stopTest();

        // THEN
        List<Event> retrievedEvents = [
            SELECT Id 
            FROM Event 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedEvents.size(), 'Expect 0 event');

        List<EmailMessage> retrievedEmailMessages = [
            SELECT 
                Id, 
                TextBody, 
                Subject, 
                FromAddress, 
                ToAddress, 
                Status, 
                MessageDate, 
                IsBounced 
            FROM EmailMessage 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedEmailMessages.size(), 'Expect 0 email message');
    }
}