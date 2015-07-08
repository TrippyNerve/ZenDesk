// This class provides test coverage for the ZendeskAPI class
@isTest
private class ZendeskAPITests {

    public class MockUserResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{"user":{"id":487700530,"url":"https://test.zendesk.com/api/v2/users/487700530.json","name":"Bob Smith","email":"bsmith1@test.com","created_at":"2014-07-02T21:57:13Z","updated_at":"2014-07-02T21:57:13Z","time_zone":"Pacific Time (US & Canada)","phone":null,"photo":null,"locale_id":1,"locale":"en-US","organization_id":null,"role":"end-user","verified":false,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":null}}');
            return res;
        }
    }
    
    static testMethod void testCreateRequest() {
        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        HttpRequest req = zapi.createRequest('GET', ZendeskAPI.BASE_PATH + '/users.json');
        Test.stopTest();

        System.assertEquals('GET', req.getMethod());
    }

    static testMethod void testCanLogin() {
        Test.setMock(HttpCalloutMock.class, new MockUserResponse());

        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        System.assertEquals(true, zapi.canLogin());
        Test.stopTest();
    }

    static testMethod void testGetPageNumber() {
        Test.startTest();
        System.assertEquals(3, ZendeskAPI.getPageNumber('https://test.zendesk.com/api/v2/tickets.json?page=3'));
        System.assertEquals(3, ZendeskAPI.getPageNumber('https://test.zendesk.com/api/v2/tickets.json?page=3&foo=bar'));
        Test.stopTest();
    }
}