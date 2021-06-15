public with sharing class LeadService {

    public static Set<String> getEmailsFromLeads(final List<Lead> leads) {
        Set<String> emails = new Set<String>();

        for (Lead theLead : leads){
            if (String.isNotBlank(theLead.Email)) {
                emails.add(theLead.Email.toLowerCase());
            }
        }

        return emails;
    }

    public static Map<String, List<Lead>> getLeadsByEmails(final Set<String> emails) {

        Map<String, List<Lead>> leadsByEmail = new Map<String, List<Lead>>();
        for (Lead theLead : LeadSelector.getLeadsByEmails(emails)) {

            if (!leadsByEmail.containsKey(theLead.Email.toLowerCase())) {
                leadsByEmail.put(theLead.Email.toLowerCase(), new List<Lead>());
            }
            leadsByEmail.get(theLead.Email.toLowerCase()).add(theLead);
        }

        return leadsByEmail;
    }

    public static void checkLeadForDuplicate(final Lead theLead, final Map<String, List<Lead>> leadsByEmails) {

        if (leadsByEmails.containsKey(theLead.Email.toLowerCase())) {
            theLead.addError('Duplicate Lead');

        } else {
            leadsByEmails.put(theLead.Email.toLowerCase(), new List<Lead>{theLead});
        }
    }
}