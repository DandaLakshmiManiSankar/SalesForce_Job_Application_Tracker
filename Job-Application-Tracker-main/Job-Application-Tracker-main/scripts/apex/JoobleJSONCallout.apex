HttpRequest req = new HttpRequest();

API_Key__mdt joobleAPIKeyMDT = API_Key__mdt.getInstance('Jooble_API_Key');

req.setEndpoint('callout:Jooble_REST_API/' + joobleAPIKeyMDT.Key__c);

req.setHeader('Content-Type', 'application/json');

req.setMethod('POST');

Map<String, Object> reqBodyMap = new Map<String, Object>{
    'keywords' => 'Junior Salesforce Developer', 
    'location' => 'Remote', 
    'radius' => '25', 
    'salary' => 50000, 
    'datecreatedfrom' => '2024-04-15', 
    'page' => '1', 
    'resultonpage' => '100'
};

req.setBody(JSON.serialize(reqBodyMap));

Http http = new Http();

HttpResponse res = http.send(req);

String resBody = res.getBody().stripHtmlTags();
// String resBody = res.getBody().replaceAll('\n', '').replaceAll('\r', '').replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('&nbsp;', '');

System.debug('resBody = ' + resBody);

if (res.getStatusCode() == 200) {
    Map<String, Object> resBodyMap = (Map<String, Object>) JSON.deserializeUntyped(resBody);

    List<Object> jobs = (List<Object>) resBodyMap.get('jobs');

    Integer loopCount = 0;

    for (Object job : jobs) {
        loopCount++;

        Map<String, Object> jobFieldMap = (Map<String, Object>) job;

        String title = String.valueOf(jobFieldMap.get('title'));
        String location = String.valueOf(jobFieldMap.get('location'));
        String snippet = String.valueOf(jobFieldMap.get('snippet'));
        String salary = String.valueOf(jobFieldMap.get('salary'));
        String source = String.valueOf(jobFieldMap.get('source'));
        String jobType = String.valueOf(jobFieldMap.get('type'));
        String link = String.valueOf(jobFieldMap.get('link'));
        String company = String.valueOf(jobFieldMap.get('company'));
        String updated = String.valueOf(jobFieldMap.get('updated'));
        String jobId = String.valueOf(jobFieldMap.get('id'));

        Datetime updatedDT = Datetime.valueof(updated.substringBefore('.').replace('T', ' '));

        System.debug('----------BEGIN LOOP ' + loopCount + ' ----------');

        System.debug('title = ' + title);
        System.debug('location = ' + location);
        System.debug('snippet = ' + snippet);
        System.debug('salary = ' + salary);
        System.debug('source = ' + source);
        System.debug('type = ' + jobType);
        System.debug('link = ' + link);
        System.debug('company = ' + company);
        System.debug('updatedDT = ' + updatedDT);
        System.debug('jobId = ' + jobId);

        System.debug('----------END LOOP ' + loopCount + ' ----------');
    }
} else {
    System.debug('HTTP request failed | Status Code: ' + res.getStatusCode());
}