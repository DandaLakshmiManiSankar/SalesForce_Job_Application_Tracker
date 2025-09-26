public with sharing class EventReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        new EventReminder().emailReminderBeforeInterviewOnNextWeekDay();
    }
}