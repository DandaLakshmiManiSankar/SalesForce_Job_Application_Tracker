@IsTest
private with sharing class EventTest {
    private static final List<String> SUBJECTS = new List<String>{
        'codeEveryDay', 
        'informationalInterview'
    };

    @TestSetup
    private static void setup() {
        List<Event> eventsToInsert = new TestDataFactory().createEvents_setup();

        if (Schema.sObjectType.Event.isCreateable()) {
            insert as user eventsToInsert;
        }
    }

    @IsTest
    private static void startDT_cannot_be_after_endDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 16, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 15, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_INTEGRITY_EXCEPTION, Event duration cannot be negative', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void startDT_cannot_be_after_endDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 16, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 15, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_INTEGRITY_EXCEPTION, Event duration cannot be negative', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_schedule_event_on_weekend_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 07, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 07, 10, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot schedule event on the weekend', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_schedule_event_on_weekend_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 07, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 07, 10, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot schedule event on the weekend', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_existingEndDT_newEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_existingEndDT_newEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_newEndDT_existingEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_newStartDT_existingStartDT_newEndDT_existingEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 09, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_existingEndDT_newEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_existingEndDT_newEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 14, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_newEndDT_existingEndDT_on_insert() {
        // GIVEN
        Event phoneScreen = new Event(
            Subject = 'phoneScreen', 
            StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00), 
            EndDateTime = Datetime.newInstance(2024, 04, 01, 12, 00, 00)
        );

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isCreateable()) {
                insert as user phoneScreen;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }

    @IsTest
    private static void cannot_overlap_event_existingStartDT_newStartDT_newEndDT_existingEndDT_on_update() {
        // GIVEN
        List<Event> eventsToUpdate = [
            SELECT 
                Id, 
                Subject, 
                StartDateTime, 
                EndDateTime 
            FROM Event 
            WHERE Subject IN :SUBJECTS 
            WITH USER_MODE
        ];

        for (Event eventToUpdate : eventsToUpdate) {
            if (eventToUpdate.Subject == 'codeEveryDay') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 06, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 07, 00, 00);
            } else if (eventToUpdate.Subject == 'informationalInterview') {
                eventToUpdate.StartDateTime = Datetime.newInstance(2024, 04, 01, 11, 00, 00);
                eventToUpdate.EndDateTime = Datetime.newInstance(2024, 04, 01, 12, 00, 00);
            }
        }

        // WHEN
        Test.startTest();

        try {
            if (Schema.sObjectType.Event.isUpdateable()) {
                update as user eventsToUpdate;
            }

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT', 
                e.getMessage().substringBetween('first error: ', ': ['), 
                'Exception message does not match: ' + e.getMessage()
            );
        }
    }
}