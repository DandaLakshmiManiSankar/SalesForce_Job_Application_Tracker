@IsTest
private with sharing class JoobleJSONCalloutTest {
    private static JoobleJSONCalloutMockGenerator joobleJSONCalloutMockGenerator = new JoobleJSONCalloutMockGenerator();

    @IsTest
    private static void make_POST_callout_creates_three_jobs() {
        // GIVEN
        joobleJSONCalloutMockGenerator.statusCode = 200;

        Test.setMock(HttpCalloutMock.class, joobleJSONCalloutMockGenerator);

        // WHEN
        Test.startTest();

        JoobleJSONCallout.makePOSTCallout(
            'Junior Salesforce Developer', 
            'Remote', 
            '25', 
            50000, 
            '2024-04-15', 
            '1', 
            '100'
        );

        Test.stopTest();

        // THEN
        final String TITLE = '%Salesforce Developer%';
        final String LOCATION = '%FL%';

        final List<String> SALARIES = new List<String>{
            '$1,234 per week', 
            '$90.1 - $95.9 per hour', 
            '$90.25k - $100.75k'
        };

        final List<String> SOURCES = new List<String>{
            'nowhere.com', 
            'somewhere.com', 
            'drjobs.ae'
        };

        final List<String> TYPES = new List<String>{
            'Full-time', 
            'Temporary'
        };

        final List<String> COMPANIES = new List<String>{
            'CodeEveryDay', 
            'Salesforce', 
            'Hirekeyz Inc'
        };

        final List<String> JOB_IDS = new List<String>{
            '-1234567890123456789', 
            '-2885668755075351000', 
            '6407669124240903000'
        };

        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c 
            WHERE Title__c LIKE :TITLE 
                AND Location__c LIKE :LOCATION 
                AND Salary__c IN :SALARIES 
                AND Source__c IN :SOURCES 
                AND Type__c IN :TYPES 
                AND Company__c IN :COMPANIES 
                AND Id__c IN :JOB_IDS 
            WITH USER_MODE
        ];

        System.assertEquals(3, retrievedJobs.size(), 'Expect 3 retrieved jobs');
    }

    @IsTest
    private static void make_POST_callout_fails() {
        // GIVEN
        joobleJSONCalloutMockGenerator.statusCode = 500;

        Test.setMock(HttpCalloutMock.class, joobleJSONCalloutMockGenerator);

        // WHEN
        Test.startTest();

        try {
            JoobleJSONCallout.makePOSTCallout(
                null, 
                null, 
                null, 
                null, 
                null, 
                null, 
                null
            );

            Test.stopTest();

            // THEN
            Assert.fail('Expect exception');
        } catch (Exception e) {
            System.assertEquals(
                'HTTP request failed | Status Code: 500', 
                e.getMessage(), 
                'Exception message does not match: ' + e.getMessage()
            );
        }

        List<Job__c> retrievedJobs = [
            SELECT Id 
            FROM Job__c 
            WITH USER_MODE
        ];

        System.assertEquals(0, retrievedJobs.size(), 'Expect 0 retrieved job');
    }
}