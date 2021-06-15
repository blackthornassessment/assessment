@IsTest
private class PreventDupLeadTest {

    @testSetup
    static void initTestData() {

        insert new Lead(FirstName = 'Bruce', LastName = 'Wayne', Email = 'brucewayne@mail.com', Company = 'Batman');
    }

    @IsTest
    static void testInsert() {

        Lead initialTestLead = new Lead( FirstName = 'Peter', LastName = 'Parker', Email = 'PeterParker@mail.com', Company = 'Spiderman');
        Database.SaveResult sr = Database.insert(initialTestLead, false);
        System.assert(sr.isSuccess());

        List<Lead> leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(2, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);

        List<Lead> leadsToInsert = new List<Lead>{
            new Lead( FirstName = 'DupPeter', LastName = 'DupParker', Email = 'PeterParker@mail.com', Company = 'Fake Spiderman'),
            new Lead( FirstName = 'DupBruce', LastName = 'DupWayne', Email = 'brucewayne@mail.com', Company = 'Fake Batman'),
            new Lead( FirstName = 'Sara', LastName = 'Connor', Email = 'saraconnor@mail.com', Company = 'Terminator')
        };

        List<Database.SaveResult> saveResults = Database.insert(leadsToInsert, false);
        System.assert(!saveResults[0].isSuccess());
        System.assert(!saveResults[1].isSuccess());
        System.assert(saveResults[2].isSuccess());

        leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(3, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);
        System.assertEquals('saraconnor@mail.com', leadsToCheck[2].Email);

        leadsToInsert = new List<Lead>{
                new Lead( FirstName = 'Dup2Peter', LastName = 'Dup2Parker', Email = 'peterPARker@mail.com', Company = 'Fake SpiderMan'),
                new Lead( FirstName = 'Dup2Bruce', LastName = 'Dup2Wayne', Email = 'BrUceWayne@mail.com', Company = 'Fake Batman'),
                new Lead( FirstName = 'DupSara', LastName = 'DupConnor', Email = 'SARaconnor@mail.com', Company = 'Fake Terminator')
        };
        saveResults = Database.insert(leadsToInsert, false);
        System.assert(!saveResults[0].isSuccess());
        System.assert(!saveResults[1].isSuccess());
        System.assert(!saveResults[2].isSuccess());

        leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(3, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);
        System.assertEquals('saraconnor@mail.com', leadsToCheck[2].Email);

        leadsToInsert = new List<Lead>{
            new Lead( FirstName = 'Thanos', LastName = 'Thanos', Email = 'thanosissuper@mail.com', Company = 'Super Thanos'),
            new Lead( FirstName = 'Tony', LastName = 'Stark', Email = 'THanosissuper@mail.com', Company = 'Avengers'),
            new Lead( FirstName = 'Steve', LastName = 'Rogers', Email = 'ThAnosissuper@mail.com', Company = 'Captain')
        };
        saveResults = Database.insert(leadsToInsert, false);
        System.assert(saveResults[0].isSuccess());
        System.assert(!saveResults[1].isSuccess());
        System.assert(!saveResults[2].isSuccess());

        leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(4, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);
        System.assertEquals('saraconnor@mail.com', leadsToCheck[2].Email);
        System.assertEquals('saraconnor@mail.com', leadsToCheck[2].Email);
        System.assertEquals('thanosissuper@mail.com', leadsToCheck[3].Email);

    }

    @IsTest
    static void testUpdate() {

        Lead initialTestLead = new Lead( FirstName = 'Peter', LastName = 'Parker', Email = 'PeterParker@mail.com', Company = 'Spiderman');
        Database.SaveResult sr = Database.insert(initialTestLead, false);
        System.assert(sr.isSuccess());

        List<Lead> leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(2, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);

        initialTestLead.Email = 'brucewayne@mail.com';

        sr = Database.update(initialTestLead, false);
        System.assert(!sr.isSuccess());

        leadsToCheck = [SELECT Id, Email FROM Lead ORDER BY Email ASC];
        System.assertEquals(2, leadsToCheck.size());
        System.assertEquals('brucewayne@mail.com', leadsToCheck[0].Email);
        System.assertEquals('peterparker@mail.com', leadsToCheck[1].Email);
    }
}