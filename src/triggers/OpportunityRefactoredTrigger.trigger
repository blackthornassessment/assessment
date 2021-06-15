trigger OpportunityRefactoredTrigger on Opportunity (before insert, before update) {

    Id renewalOppRecordTypeId = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('renewal').getRecordTypeId();
    Set<String> accIds = new Set<String>();

    for (Opportunity opp : Trigger.new) {
        if (String.isNotBlank(opp.AccountId)) {
            accIds.add(opp.AccountId);
        }
    }

    Map<Id, Account> accounts = new Map<Id,Account>([SELECT Id, CustomField__c FROM Account WHERE Id IN : accIds]);

    For(Opportunity p : Trigger.New){

        if(p.CloseDate < Date.today()){
            p.StageName = 'Closed Won';
            p.RecordTypeId = renewalOppRecordTypeId;
        }

        if (String.isNotBlank(p.AccountId)
                && accounts.containsKey(p.AccountId)) {
            p.CustomField__c = accounts.get(p.AccountId).CustomField__c;
        }
    }
}