public with sharing class EventLimitationService {

    public static Event_Limitation__c ORG_DEFAULT_LIMITATION_LIMITATION = Event_Limitation__c.getOrgDefaults();

    public static Event_Limitation__c userSettings {
        get {
            userSettings = Event_Limitation__c.getInstance();
            if (null == userSettings.Id) {
                userSettings.Events_Limit__c = ORG_DEFAULT_LIMITATION_LIMITATION.Events_Limit__c;
                userSettings.Current_Event_Count__c = 0;
                userSettings.Month__c = Date.today().month();
                insert userSettings;
            }

            if (Date.today().month() != userSettings.Month__c) {
                userSettings.Month__c = Date.today().month();
                userSettings.Current_Event_Count__c = 0;
                update userSettings;
            }

            return userSettings;
        }
        set;
    }

    public class EventLimitationException extends Exception {}
}