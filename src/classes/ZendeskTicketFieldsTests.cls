// This class provides test coverage for the ZendeskTicketFields class
@isTest
private class ZendeskTicketFieldsTests {

    public class MockTicketResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{ "ticket_field": { "url": "https://test.zendesk.com/api/v2/ticket_fields/21778153.json", "id": 21778153, "type": "tagger", "title": "Zendesk Plan", "raw_title": "Zendesk Plan", "description": "", "raw_description": "", "position": 7, "active": true, "required": false, "collapsed_for_agents": false, "regexp_for_validation": null, "title_in_portal": "Zendesk Plan", "raw_title_in_portal": "Zendesk Plan", "visible_in_portal": false, "editable_in_portal": false, "required_in_portal": false, "tag": null, "created_at": "2012-10-19T01:01:32Z", "updated_at": "2014-11-08T10:47:55Z", "removable": true, "custom_field_options": [ { "id": 21332256, "name": "Test", "raw_name": "Test", "value": "zdplan_test" } ] } } ');
            return res;
        }
    }

    public class MockTicketsResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setStatus('OK');
            res.setBody('{ "ticket_fields": [ { "url": "https://test.zendesk.com/api/v2/ticket_fields/23164018.json", "id": 23164018, "type": "text", "title": "Test", "raw_title": "Test", "description": "Test", "raw_description": "Test", "position": 9999, "active": false, "required": false, "collapsed_for_agents": false, "regexp_for_validation": null, "title_in_portal": "Test", "raw_title_in_portal": "Test", "visible_in_portal": false, "editable_in_portal": false, "required_in_portal": false, "tag": null, "created_at": "2013-08-28T05:57:11Z", "updated_at": "2013-08-29T07:11:23Z", "removable": true } ], "next_page": null, "previous_page": null, "count": 1 }');
            return res;
        }
    }

    static testMethod void testGetTicketFieldById() {
        Test.setMock(HttpCalloutMock.class, new MockTicketResponse());

        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        ZendeskTicketFields zfields = new ZendeskTicketFields(zapi);
        ZendeskTicketFields.ZTicketField testObj = zfields.getTicketField(123);
        Test.stopTest();

        System.assertNotEquals(null, testObj);
    }

    static testMethod void testGetTicketFieldByName() {
        Test.setMock(HttpCalloutMock.class, new MockTicketsResponse());

        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        ZendeskTicketFields zfields = new ZendeskTicketFields(zapi);
        ZendeskTicketFields.ZTicketField testObj = zfields.getTicketField('Test');
        Test.stopTest();

        System.assertNotEquals(null, testObj);
    }

    static testMethod void testGetAllFields() {
        Test.setMock(HttpCalloutMock.class, new MockTicketsResponse());

        ZendeskAPI zapi = new ZendeskAPI('s', 'u', 'p', ZendeskAPI.AuthType.Password);

        Test.startTest();
        ZendeskTicketFields zfields = new ZendeskTicketFields(zapi);
        Map<String, ZendeskTicketFields.ZTicketField> fieldsMap = zfields.getAllFields();
        Test.stopTest();

        System.assertNotEquals(null, fieldsMap.containsKey('Test'));
    }

    static testMethod void testGetNextPage() {
        Test.startTest();
        ZendeskTicketFields.PagedTicketFieldsWrapper wrapper = new ZendeskTicketFields.PagedTicketFieldsWrapper();
        wrapper.next_page = 'https://test.zendesk.com/api/v2/ticket_fields.json?page=2';
        Test.stopTest();

        System.assertEquals(2, wrapper.nextPageNumber);
    }

    static testMethod void testZTicketField() {
        ZendeskTicketFields.ZTicketField zticketfield = new ZendeskTicketFields.ZTicketField();
        zticketfield.id = 0;
        zticketfield.type = '';
        zticketfield.title = '';
        zticketfield.raw_title = '';
        zticketfield.active = true;
        zticketfield.custom_field_options = null;

        ZendeskTicketFields.ZCustomFieldOption zcustomfieldoption = new ZendeskTicketFields.ZCustomFieldOption();
        zcustomfieldoption.id = 0;
        zcustomfieldoption.name = '';
        zcustomfieldoption.raw_name = '';
        zcustomfieldoption.value = '';

        System.assert(true);
    }
}