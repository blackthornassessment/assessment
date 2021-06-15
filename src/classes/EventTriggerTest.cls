@IsTest
private class EventTriggerTest {
    @testSetup
    static void initTestData() {
        insert new Event_Limitation__c(SetupOwnerId = UserInfo.getOrganizationId(), Events_Limit__c = 100, Current_Event_Count__c = 0, Month__c = Date.today().month());
    }

    @IsTest
    static void testInsert() {

        List<Event__c> events = new List<Event__c>();

        for (Integer i = 0; i < 200; i++) {
            events.add(new Event__c(Name = 'gdfgdfgd Event'+i, UID__c = 'afgsfgs' + i));
        }

        Test.startTest();
        List<Database.SaveResult> svResults = Database.insert(events, false);
        Test.stopTest();

        List<Event__c> eventsToCheck = [SELECT Id FROM Event__c];
        System.assertEquals(100, eventsToCheck.size());
        System.assertEquals(100, EventLimitationService.userSettings.Current_Event_Count__c);

        Event_Limitation__c lim = Event_Limitation__c.getInstance();
        lim.Month__c = 1 != lim.Month__c ? 1 : 2;
        update lim;

        events.clear();
        for (Integer i = 0; i < 50 ; i++) {
            events.add(new Event__c(Name = 'New Event'+i, UID__c = 'dfhdh' + i));
        }
        svResults = Database.insert(events, false);

        eventsToCheck = [SELECT Id FROM Event__c];
        System.assertEquals(150, eventsToCheck.size());
        System.assertEquals(50, EventLimitationService.userSettings.Current_Event_Count__c);

    }
}