trigger EventTrigger on Event__c (before insert) {

    Event_Limitation__c userSettings = EventLimitationService.userSettings;

    for (Event__c evt : Trigger.new) {
        if (userSettings.Current_Event_Count__c >= userSettings.Events_Limit__c) {
            evt.addError('Too many Events created this month for user ' + UserInfo.getName() + '(' + UserInfo.getUserId() + '): ' + userSettings.Events_Limit__c);
            continue;
        }

        userSettings.Current_Event_Count__c += 1;
    }

    update userSettings;
}