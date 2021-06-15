@RestResource(urlMapping='/EventApplication')
global with sharing class EventApplicationControllerREST {

    @HttpPost
    global static String doEventApplicationPost(final List<EventApplication> eventApplications) {

        List<Event_Application__c> eventApps = buildEventApplicationsFromRequest(eventApplications);
        List<Database.SaveResult> saveResults = Database.insert(eventApps, false);
        return buildResponse(saveResults, eventApps);
    }

    private static String buildResponse(final List<Database.SaveResult> saveResults, final List<Event_Application__c> eventApps) {

        List<EventApplicationResponse> response = new List<EventApplicationResponse>();

        for (Integer i = 0; i < saveResults.size(); i++) {
            response.add(buildRecordResponse(saveResults[i], eventApps[i]));
        }

        return JSON.serialize(response);
    }

    private static EventApplicationResponse buildRecordResponse(final Database.SaveResult sr, Event_Application__c evtApp) {
        String errorMessage = sr.isSuccess() ? null : sr.getErrors()[0].getMessage();
        return new EventApplicationResponse(evtApp.Event__r.UID__c, evtApp.Applicant__r.UID__c, sr.isSuccess(), errorMessage);
    }

    private static List<Event_Application__c> buildEventApplicationsFromRequest(final List<EventApplication> eventApplications) {

        List<Event_Application__c> eventApps = new List<Event_Application__c>();

        for (EventApplication evtApp : eventApplications) {
            for (String eventUID : evtApp.events) {
                for (String applicantUID : evtApp.applicants) {

                    eventApps.add(new Event_Application__c(
                       Event__r = new Event__c(UID__c = eventUID),
                       Applicant__r = new Contact(UID__c = applicantUID)
                    ));
                }
            }
        }

        return eventApps;
    }

    global class EventApplication {
        global List<String> events {get;set;}
        global List<String> applicants {get;set;}
    }

    global class EventApplicationResponse {
        global String eventUID {get;set;}
        global String applicantUID {get;set;}
        global Boolean isSubmitted {get;set;}
        global String errorMessage {get;set;}

        global EventApplicationResponse(final String eventUID, final String applicantUId, final Boolean isSubmitted, final String errorMessage) {
            this.eventUID = eventUID;
            this.applicantUID = applicantUID;
            this.isSubmitted = isSubmitted;
            this.errorMessage = errorMessage;
        }
    }

}