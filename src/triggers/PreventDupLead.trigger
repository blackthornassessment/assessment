trigger PreventDupLead on Lead (before insert, before update) {

    Map<String, List<Lead>> leadsByEmail = LeadService.getLeadsByEmails(LeadService.getEmailsFromLeads(Trigger.new));

    for(Lead aLead : Trigger.new) {
        if (null == Trigger.oldMap
                || Trigger.oldMap.get(aLead.Id).Email != aLead.Email) {

            LeadService.checkLeadForDuplicate(aLead, leadsByEmail);
        }
    }
}