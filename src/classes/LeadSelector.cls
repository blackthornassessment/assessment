public with sharing class LeadSelector {

    public static List<Lead> getLeadsByEmails(final Set<String> emails) {
        return [SELECT Id, Email FROM Lead WHERE Email IN : emails];
    }

}