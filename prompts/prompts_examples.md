# Lead Score
Write a Salesforce formula field to calculate the lead score based on the following criteria:
- If the lead source(LeadSource) is from the website and an email exists, increment score by 3 points.
- If the lead provides a phone number(Phone), increment score by 5 points.
- If the lead belongs to the 'Technology' industry(Industry), increment score by another 10 points.

Create a description and help text for the formula field.


# Lead Score Enhancement 
## Find related leads or contacts with the same email
Write a Salesforce Apex trigger to find related leads or contacts with the same email and update the rating(Rating) to "Hot" if found.
Use this initial trigger code:
```
for (Lead lead : trigger.new) {
	List<Lead> foundLeads = [SELECT Id, Email FROM Lead WHERE Email = :lead.Email];
	List<Contact> foundContacts = [SELECT Id, Email FROM Contact WHERE Email = :lead.Email];
}
