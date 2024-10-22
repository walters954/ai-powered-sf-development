public with sharing class LeadTriggerHandler {

	public static void handleTitleNormalization(List<Lead> leadsToNormalize) {
		for (Lead ld : leadsToNormalize) {
			if (ld.Title == null) {
				continue; // Skip if title is null (no need to normalize)
			}

			String title = ld.Title.toLowerCase(); // Convert title to lowercase for easier matching

			// Check and replace based on the specified conditions
			if (title.contains('vp') || title.contains('v.p.') || title.contains('vice president')) {
				ld.Title = 'Vice President';
			} else if (title.contains('mgr') || title.contains('manage') || title.contains('head of department')) {
				ld.Title = 'Manager';
			} else if (title.contains('exec') || title.contains('chief') || title.contains('head')) {
				ld.Title = 'Executive';
			} else if (title.contains('assist') || title.contains('deputy') || title.contains('jr')) {
				ld.Title = 'Assistant';
			}
		}
	}


	public static void handleAutoLeadScoring(List<Lead> leadsToScore) {
		for (Lead ld : leadsToScore) {
			Integer score = 0; // Ensure we have a starting score

			// Check and add points based on the specified conditions
			if (ld.LeadSource == 'Web' && ld.Email != null) {
				score += 3;
			}

			if (ld.Phone != null) {
				score += 5;
			}

			if (ld.Industry == 'Technology') {
				score += 10;
			}

			ld.Lead_Score__c = score; // Set the computed score back to the lead
		}
	}


	public static void handleLeadAutoConvert(List<Lead> leads) {
		Map<Id, String> leadToEmailMap = new Map<Id, String>();
		for (Lead lead : leads) {
			if (Lead.IsConverted == false) {
				leadToEmailMap.put(lead.Id, lead.Email);
			}
		}

		Map<String, Contact> emailToContactMap = new Map<String, Contact>();
		for (Contact c : [SELECT Id, Email, AccountId FROM Contact WHERE Email IN :leadToEmailMap.values()]) {
			if (!emailToContactMap.containsKey(c.Email)) {
				emailToContactMap.put(c.Email, c);
			} else {
				emailToContactMap.remove(c.Email);
			}
		}

		List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];
		for (Id leadId : leadToEmailMap.keySet()) {
			String leadEmail = leadToEmailMap.get(leadId);
			if (emailToContactMap.containsKey(leadEmail)) {
				Database.LeadConvert lc = new Database.LeadConvert();
				lc.setLeadId(leadId);
				lc.setContactId(emailToContactMap.get(leadEmail).Id); // Use existing Contact Id
				lc.setAccountId(emailToContactMap.get(leadEmail).AccountId); // Use existing Account Id
				lc.setDoNotCreateOpportunity(true); // Assuming we don't want to create an opportunity
				lc.setConvertedStatus(convertStatus.MasterLabel); // Set the converted status
				leadConverts.add(lc);
			}
		}

		if (!leadConverts.isEmpty()) {
			List<Database.LeadConvertResult> lcrs = Database.convertLead(leadConverts);
		}
	}
}