/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
public with sharing class LeadTriggerTest {

    @IsTest
    static void testUpdateLeadScoreOnRelatedRecordsPositive() {
        // Create a test lead with a valid email
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'testlead@example.com',
            Lead_Score__c = 0
        );
        insert testLead;
        
        // Create a test contact with the same email
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testlead@example.com'
        );
        insert testContact;
        
        // Retrieve the test lead
        testLead = [SELECT Id, Rating, Lead_Score__c FROM Lead WHERE Id = :testLead.Id];
        
        // Verify that the rating is 'Hot' and the lead score is 10
        System.assertEquals('Hot', testLead.Rating, 'Rating should be Hot');
        System.assertEquals(10, testLead.Lead_Score__c, 'Lead Score should be 10');
    }

    @isTest
    private static void testMultipleLeads(){
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead testLead = new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'Test Company',
                Email = 'testlead' + i + '@example.com',
                Lead_Score__c = 0
            );
            leads.add(testLead);
        }
        Test.startTest();
        insert leads;
        Test.stopTest();
        List<Lead> updatedLeads = [SELECT Id, Rating, Lead_Score__c FROM Lead WHERE Id IN :leads];
    }

}