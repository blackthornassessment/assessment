@IsTest
private class OpportunityRefactoredTriggerTest {

    @testSetup
    static void initTestData() {
        insert new Account(Name = 'Some Name', CustomField__c = 'ABC');
    }


    @IsTest
    static void testDataInsert() {

        final List<Account> accounts = [SELECT Id, CustomField__c FROM Account];
        System.assertEquals(1, accounts.size());

        Map<String, RecordTypeInfo> oppRecTypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        List<Opportunity> opps = new List<Opportunity> {
                new Opportunity(Name = 'Some Opp', AccountId = accounts[0].Id, StageName = 'Prospecting', CloseDate = Date.today().addDays(-1), CustomField__c = 'nbnb', RecordTypeId = oppRecTypes.get('Other').getRecordTypeId()),
                new Opportunity(Name = 'WWW', AccountId = accounts[0].Id, StageName = 'Prospecting', CloseDate = Date.today().addDays(1), CustomField__c = 'nbnb', RecordTypeId = oppRecTypes.get('Other').getRecordTypeId())
        };

        Test.startTest();
        insert opps;
        Test.stopTest();

        final List<Opportunity> oppsToCheck = [SELECT Id, StageName, CustomField__c, RecordTypeId FROM Opportunity ORDER By Name ASC];
        System.assertEquals(2, oppsToCheck.size());
        System.assertEquals(accounts[0].CustomField__c, oppsToCheck[0].CustomField__c);
        System.assertEquals(accounts[0].CustomField__c, oppsToCheck[1].CustomField__c);
        System.assertEquals(accounts[0].CustomField__c, oppsToCheck[1].CustomField__c);
        System.assertEquals('Closed Won', oppsToCheck[0].StageName);
        System.assertEquals('Prospecting', oppsToCheck[1].StageName);
        System.assertEquals(oppRecTypes.get('renewal').getRecordTypeId(), oppsToCheck[0].RecordTypeId);
        System.assertEquals(oppRecTypes.get('Other').getRecordTypeId(), oppsToCheck[1].RecordTypeId);
    }
}