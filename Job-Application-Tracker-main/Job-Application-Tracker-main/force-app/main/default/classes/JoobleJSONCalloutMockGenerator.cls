public with sharing class JoobleJSONCalloutMockGenerator implements HttpCalloutMock {
    @TestVisible
    private Integer statusCode;

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');

        if (req.getMethod() == 'POST') {
            res.setBody(
                '{"totalCount":3,"jobs":[{"title":"Junior Salesforce Developer","location":"Orlando, FL","snippet":"","salary":"$1,234 per week","source":"nowhere.com","type":"Full-time","link":"https://careers.codeeveryday.com/en/jobs","company":"CodeEveryDay","updated":"2024-04-15T00:00:00.0000000","id":-1234567890123456789},{"title":"Salesforce Developer","location":"Jacksonville, FL","snippet":"","salary":"$90.1 - $95.9 per hour","source":"somewhere.com","type":"Temporary","link":"https://careers.salesforce.com/en/jobs","company":"Salesforce","updated":"2024-04-16T00:00:00.0000000","id":-2885668755075351000},{"title":"Sr Salesforce Developer","location":"Tampa, FL","snippet":"&nbsp;...POSITION  \r\n  Sr <b>Salesforce Developer </b> \r\n\r\n     LOCATION  \r\n  Tampa FL Hybrid  \r\n\r\n     DURATION  \r\n 6 months  \r\n\r\n     INTERVIEW TYPE  \r\n  Video  \r\n\r\n     REQUIRED SKILLS  \r\n  \r\n Financial Services experience highly preferred   \r\n Needs a background in other programming...&nbsp;","salary":"$90.25k - $100.75k","source":"drjobs.ae","type":"Temporary","link":"https://jooble.org/desc/6407669124240902847?ckey=Salesforce+Developer&rgn=10&pos=20&groupId=40906&elckey=6560772729242811828&p=1&aq=426136413298815402&cid=3389&jobAge=133&relb=100&brelb=100&bscr=7124.704&scr=7124.704000000001","company":"Hirekeyz Inc","updated":"2024-04-17T00:00:00.0000000","id":6407669124240903000}]}'
            );
        }

        res.setStatusCode(statusCode);

        return res;
    }
}