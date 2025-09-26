trigger EventTrigger on Event (before insert, before update) {
    EventTriggerHandler eventTriggerHandler = new EventTriggerHandler();

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            eventTriggerHandler.validateEventDateTime(Trigger.new);
        }

        when BEFORE_UPDATE {
            eventTriggerHandler.validateEventDateTime(Trigger.new);
        }
    }
}