public with sharing class TestDataFactory {
	public static Account createAccount(String name) {
		Account account = new Account();
		account.Name = name;
		account.Industry = 'Technology';
		account.Type = 'Customer - Direct';
		return account;
	}

	public static Contact createContact(Id accountId, String email, Boolean doInsert) {
		Contact contact = new Contact();
		contact.AccountId = accountId;
		contact.Email = email;
		contact.FirstName = 'Test';
		contact.LastName = 'Contact';
		contact.Fax = '123-456-7890';
		if (doInsert) {
			insert contact;
		}
		return contact;
	}

	public static List<Lead> createLeads(Integer numLeads, String email, Boolean doInsert) {
		List<Lead> leads = new List<Lead>();
		for (Integer i = 0; i < numLeads; i++) {
			Lead lead = createLead(email, false);
			leads.add(lead);
		}
		if (doInsert) {
			insert leads;
		}
		return leads;
	}

	public static Lead createLead(String email, Boolean doInsert) {
		Lead lead = new Lead();
		lead.Email = email;
		lead.FirstName = 'Test';
		lead.LastName = 'Lead';
		lead.Company = 'Test Company';
		return lead;
	}
}