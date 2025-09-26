public with sharing class EventReminder {
    @TestVisible
    private Datetime now = System.now();

    public void emailReminderBeforeInterviewOnNextWeekDay() {
        Datetime nextWeekDayBegin = (Datetime) getNextWeekDayOrDay(now, true);
        Datetime nextWeekDayEnd = nextWeekDayBegin + 1;

        List<Event> events = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime, 
                Location, 
                Account.Name, 
                Type, 
                Description, 
                Who.Name, 
                OwnerId, 
                Interview_Format__c 
            FROM Event 
            WHERE StartDateTime >= :nextWeekDayBegin 
                AND StartDateTime < :nextWeekDayEnd 
            WITH USER_MODE
        ];

        if (events.isEmpty()) {
            return;
        }

        Set<Id> eventOwnerIds = new Set<Id>();

        for (Event event : events) {
            eventOwnerIds.add(event.OwnerId);
        }

        List<User> users = [
            SELECT 
                Id, 
                Email 
            FROM User 
            WHERE Id = :eventOwnerIds 
            WITH USER_MODE
        ];

        Map<Id, String> emailsByEventId = new Map<Id, String>();

        for (Event event : events) {
            for (User user : users) {
                if (event.OwnerId == user.Id && !emailsByEventId.containsKey(event.Id)) {
                    emailsByEventId.put(event.Id, user.Email);

                    break;
                }
            }
        }

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        final String DAY = (String) getNextWeekDayOrDay(now, false);

        for (Event event : events) {
            List<String> emailAddresses = new List<String>{emailsByEventId.get(event.Id)};

            mails.add(createEmailToSend(emailAddresses, event, DAY, event.Who.Name));
        }

        Messaging.sendEmail(mails);
    }

    @TestVisible
    private Object getNextWeekDayOrDay(Datetime now, Boolean returnNextWeekDay) {
        final String FRI = 'Fri';
        final String SAT = 'Sat';
        final String DAY;

        Datetime nextWeekDayBegin;

        if (now.format('E') == FRI) {
            nextWeekDayBegin = getDatetimeWithoutTime(now + 3);

            DAY = 'in 3 days';
        } else if (now.format('E') == SAT) {
            nextWeekDayBegin = getDatetimeWithoutTime(now + 2);

            DAY = 'in 2 days';
        } else {
            nextWeekDayBegin = getDatetimeWithoutTime(now + 1);

            DAY = 'tomorrow';
        }

        if (returnNextWeekDay) {
            return nextWeekDayBegin;
        } else {
            return DAY;
        }
    }

    private Datetime getDatetimeWithoutTime(Datetime dt) {
        return Datetime.newInstance(dt.year(), dt.month(), dt.day(), 00, 00, 00);
    }

    private Messaging.SingleEmailMessage createEmailToSend(
        List<String> emailAddresses, 
        Event event, 
        String day, 
        String contactName
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(emailAddresses);

        mail.setSubject('Reminder — Event ' + day);

        final String HTML_BODY = 
            '<html><body>' 
            + 'You have a scheduled event ' + day + '<br><br>' 
            + 'Subject: <br>' + event.Subject +'<br><br>' 
            + 'Start: <br>' + event.StartDateTime.formatLong() +'<br><br>' 
            + 'End: <br>' + event.EndDateTime.formatLong() +'<br><br>' 
            + 'Contact: <br>' + contactName +'<br><br>' 
            + 'Location: <br>' + event.Location +'<br><br>' 
            + 'Company or Organization: <br>' + event.Account.Name +'<br><br>' 
            + 'Type: <br>' + event.Type +'<br><br>' 
            + 'Interview Format: <br>' + event.Interview_Format__c +'<br><br>' 
            + 'Description: <br>' + event.Description 
            + '</body></html>';

        mail.setHtmlBody(HTML_BODY);

        return mail;
    }
}