@isTest
public with sharing class LeadTriggerHandlerTest {
	@isTest
	static void leadTriggerInsert_handleTitleNormalization_titleUpdate() {
		List<Lead> leads = new List<Lead>();
		Lead lead = new Lead(FirstName = 'Test', LastName = 'Test', Title = 'vp', Company = 'Test');
		leads.add(lead);

		Test.startTest();
		insert leads; //used 1 dml
		Test.stopTest();

		Lead updatedLead = [SELECT Id, Title FROM Lead WHERE Id = :lead.Id];

		Assert.areEqual('Vice President', updatedLead.Title, 'Title should be updated to Vice President');
	}

	@isTest
	static void leadTriggerHandler_handleTitleNormalization_titleUpdate() {
		List<Lead> leads = new List<Lead>();
		Lead lead = new Lead(FirstName = 'Test', LastName = 'Test', Title = 'vp', Company = 'Test');
		leads.add(lead);
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'mgr', Company = 'Test'));
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'exec', Company = 'Test'));
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'deputy', Company = 'Test'));
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = '', Company = 'Test'));
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = null, Company = 'Test'));
		leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = '@#$@#$@', Company = 'Test'));

		Test.startTest();
		LeadTriggerHandler.handleTitleNormalization(leads);
		Test.stopTest();

		Lead updatedLead = leads[0];

		Assert.areEqual('Vice President', updatedLead.Title, 'Title should be updated to Vice President');
		Assert.areEqual('Manager', leads[1].Title, 'Title should be updated to Manager');
		Assert.areEqual('Executive', leads[2].Title, 'Title should be updated to Executive');
		Assert.areEqual('Assistant', leads[3].Title, 'Title should be updated to Assistant');
	}

	@testSetup
	static void setup() {
		// Create common test accounts
		List<Lead> leads = new List<Lead>();
		Integer numberOfLeads = 400;
		for (Integer i = 0; i < numberOfLeads; i++) {
			leads.add(new Lead(FirstName = 'Test' + i, LastName = 'Test' + i, Company = 'Test' + i));
		}
		insert leads;
	}

	@isTest
	static void leadTriggerHandler_handleAutoLeadScoring() {
		List<Lead> leads = [
			SELECT Id, FirstName, LastName, Company, Title, Lead_Score__c, LeadSource, Email, Industry, Phone
			FROM Lead
		];

		for (Lead lead : leads) {
			Integer count = 0;

			if (Math.mod(count, 4) == 0) {
				lead.FirstName = '3';
				lead.LeadSource = 'Web';
				lead.Email = 'warren@cloudcodeacademy.com';
			} else if (Math.mod(count, 4) == 1) {
				lead.FirstName = '5';
				lead.Phone = '9541231234';
			} else if (Math.mod(count, 4) == 2) {
				lead.FirstName = '10';
				lead.Industry = 'Technology';
			} else if (Math.mod(count, 4) == 3) {
				lead.FirstName = '18';
				lead.LeadSource = 'Web';
				lead.Email = 'warren@cloudcodeacademy.com';
				lead.Phone = '9541231234';
				lead.Industry = 'Technology';
			}
			count++;
		}

		Test.startTest();
		LeadTriggerHandler.handleAutoLeadScoring(leads);
		Test.stopTest();

		for (Lead lead : leads) {
			Assert.areEqual(Integer.valueOf(lead.firstName), lead.Lead_Score__c, 'Lead score should be updated');
		}
	}

	@isTest
	static void leadTriggerHandler_handleLeadAutoConvert() {
		Account acc = TestDataFactory.createAccount('Test Account');
		insert acc;
		TestDataFactory.createContact(acc.Id, 'test@email.com', true);
		Integer numberOfLeads = 400;

		List<Lead> leads = TestDataFactory.createLeads(numberOfLeads, 'test@email.com', false);

		Test.startTest();
		insert leads;
		Test.stopTest();

		Lead[] updatedLeads = [SELECT Id, IsConverted FROM Lead WHERE Id IN :leads];
		Assert.isTrue(updatedLeads.size() == numberOfLeads, 'All leads should be updated');
		for (Lead lead : updatedLeads) {
			Assert.isTrue(lead.IsConverted, 'Lead should be converted');
		}
	}
}