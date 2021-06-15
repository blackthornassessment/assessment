@IsTest
private class EventApplicationControllerRESTTest {

    @testSetup
    static void initTestData() {

        insert new List<Contact>{
            new Contact(FirstName = 'Bruce', LastName = 'Wayne', Email = 'brucewayne@mail.com', UID__c = '1111'),
            new Contact(FirstName = 'Peter', LastName = 'Parker', Email = 'peterparker@mail.com', UID__c = '2222')
        };

        insert new List<Event__c> {
            new Event__c(Name = 'Some Fancy event', Status__c = 'Not Started', Start_Date__c = Datetime.now().addDays(1), End_Date__c = Datetime.now().addDays(2), UID__c = '1234'),
            new Event__c(Name = 'Some Virtual event', Status__c = 'Not Started', Start_Date__c = Datetime.now().addDays(1), End_Date__c = Datetime.now().addDays(2), UID__c = '5678')
        };
    }

    @IsTest
    static void testDoEventApplicationPost() {

        final List<Contact> contacts = [SELECT Id, UID__c FROM Contact ORDER BY UID__c ASC];
        System.assertEquals(2, contacts.size());

        final List<Event__c> events = [SELECT Id, UID__c FROM Event__c ORDER BY UID__c ASC];
        System.assertEquals(2, events.size());

        EventApplicationControllerREST.EventApplication evtAppPayload = new EventApplicationControllerREST.EventApplication();
        evtAppPayload.events = new List<String> {'1234'};
        evtAppPayload.applicants = new List<String> {'1111'};

        Test.startTest();
        String response = EventApplicationControllerREST.doEventApplicationPost(new List<EventApplicationControllerREST.EventApplication>{evtAppPayload});

        List<EventApplicationControllerREST.EventApplicationResponse> evtAppResponse = (List<EventApplicationControllerREST.EventApplicationResponse>)JSON.deserialize(response, List<EventApplicationControllerREST.EventApplicationResponse>.class);
        System.assertEquals(1, evtAppResponse.size());
        System.assert(evtAppResponse[0].isSubmitted);
        System.assertEquals(null, evtAppResponse[0].errorMessage);
        System.assertEquals(contacts[0].UID__c, evtAppResponse[0].applicantUID);
        System.assertEquals(events[0].UID__c, evtAppResponse[0].eventUID);

        List<Event_Application__c> evtApplications = [SELECT Id, Event__c, Applicant__c FROM Event_Application__c];
        System.assertEquals(1, evtApplications.size());
        System.assertEquals(contacts[0].Id, evtApplications[0].Applicant__c);
        System.assertEquals(events[0].Id, evtApplications[0].Event__c);

        evtAppPayload.events = new List<String> {'1234', '5678'};
        evtAppPayload.applicants = new List<String> {'1111', '2222'};

        response = EventApplicationControllerREST.doEventApplicationPost(new List<EventApplicationControllerREST.EventApplication>{evtAppPayload});
        Test.stopTest();

        evtAppResponse = (List<EventApplicationControllerREST.EventApplicationResponse>)JSON.deserialize(response, List<EventApplicationControllerREST.EventApplicationResponse>.class);
        System.assertEquals(4, evtAppResponse.size());
        System.assert(!evtAppResponse[0].isSubmitted);
        System.assert(String.isNotBlank(evtAppResponse[0].errorMessage));
        System.assertEquals(contacts[0].UID__c, evtAppResponse[0].applicantUID);
        System.assertEquals(events[0].UID__c, evtAppResponse[0].eventUID);

        Map<String, Integer> applicationsByEvent = new Map<String, Integer>();
        Map<String, Integer> applicationsByUsers = new Map<String, Integer>();

        evtApplications = [SELECT Id, Event__c, Applicant__c FROM Event_Application__c];
        System.assertEquals(4, evtApplications.size());

        for (Event_Application__c evtApp : evtApplications) {

            if (!applicationsByEvent.containsKey(evtApp.Event__c)) {
                applicationsByEvent.put(evtApp.Event__c, 0);
            }

            if (!applicationsByUsers.containsKey(evtApp.Applicant__c)) {
                applicationsByUsers.put(evtApp.Applicant__c, 0);
            }

            Integer count = applicationsByEvent.get(evtApp.Event__c);
            applicationsByEvent.put(evtApp.Event__c, ++count);

            count = applicationsByUsers.get(evtApp.Applicant__c);
            applicationsByUsers.put(evtApp.Applicant__c, ++count);
        }

        for (Contact cont : contacts) {
            System.assertEquals(2, applicationsByUsers.get(cont.Id));
        }

        for (Event__c evt : events) {
            System.assertEquals(2, applicationsByEvent.get(evt.Id));
        }
    }
}