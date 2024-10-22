trigger LeadTrigger on Lead(before insert, before update, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            LeadTriggerHandler.handleTitleNormalization(Trigger.new);
            LeadTriggerHandler.handleAutoLeadScoring(Trigger.new);
        }
        when BEFORE_UPDATE {
            LeadTriggerHandler.handleTitleNormalization(Trigger.new);
            LeadTriggerHandler.handleAutoLeadScoring(Trigger.new);
        }
        when AFTER_INSERT {
            LeadTriggerHandler.handleLeadAutoConvert(Trigger.new);
        }
        when AFTER_UPDATE {
            LeadTriggerHandler.handleLeadAutoConvert(Trigger.new);
        }
    }
}