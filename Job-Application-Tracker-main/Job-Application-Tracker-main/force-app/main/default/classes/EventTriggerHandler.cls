public with sharing class EventTriggerHandler {
    public void validateEventDateTime(List<Event> triggerDotNew) {
        List<Event> events = [
            SELECT 
                StartDateTime, 
                EndDateTime
            FROM Event 
            WHERE Event.Id NOT IN :triggerDotNew 
            WITH USER_MODE
        ];

        for (Event newEvent : triggerDotNew) {
            Datetime newEventStartDT = newEvent.StartDateTime;
            Datetime newEventEndDT = newEvent.EndDateTime;

            Long newEventStartDTInMilliseconds = newEventStartDT.getTime();
            Long newEventEndDTInMilliseconds = newEventEndDT.getTime();

            if (isWeekend(newEventStartDT) || isWeekend(newEventEndDT)) {
                newEvent.addError('Cannot schedule event on the weekend');
            } else if (!events.isEmpty()) {
                final String ERROR = validateNoEventOverlap(events, newEventStartDTInMilliseconds, newEventEndDTInMilliseconds);

                if (error != null) {
                    newEvent.addError(ERROR);
                }
            }
        }
    }

    private Boolean isWeekend(Datetime dt) {
        final String SAT = 'Sat';
        final String SUN = 'Sun';

        if (dt.format('E') == SAT || dt.format('E') == SUN) {
            return true;
        } else {
            return false;
        }
    }

    private String validateNoEventOverlap(List<Event> events, Long newEventStartDTInMilliseconds, Long newEventEndDTInMilliseconds) {
        final String ERROR;

        for (Event event : events) {
            Long eventStartDTInMilliseconds = event.StartDateTime.getTime();
            Long eventEndDTInMilliseconds = event.EndDateTime.getTime();

            if (
                (newEventStartDTInMilliseconds <= eventStartDTInMilliseconds && eventStartDTInMilliseconds < newEventEndDTInMilliseconds) 
                && (newEventStartDTInMilliseconds < eventEndDTInMilliseconds && eventEndDTInMilliseconds <= newEventEndDTInMilliseconds)
            ) {
                ERROR = 'Cannot overlap event: newStartDT existingStartDT existingEndDT newEndDT';
            } else if (
                (newEventStartDTInMilliseconds <= eventStartDTInMilliseconds && eventStartDTInMilliseconds < newEventEndDTInMilliseconds) 
                && (eventStartDTInMilliseconds < newEventEndDTInMilliseconds && newEventEndDTInMilliseconds <= eventEndDTInMilliseconds)
            ) {
                ERROR = 'Cannot overlap event: newStartDT existingStartDT newEndDT existingEndDT';
            } else if (
                (eventStartDTInMilliseconds <= newEventStartDTInMilliseconds && newEventStartDTInMilliseconds < eventEndDTInMilliseconds) 
                && (newEventStartDTInMilliseconds < eventEndDTInMilliseconds && eventEndDTInMilliseconds <= newEventEndDTInMilliseconds)
            ) {
                ERROR = 'Cannot overlap event: existingStartDT newStartDT existingEndDT newEndDT';
            } else if (
                (eventStartDTInMilliseconds <= newEventStartDTInMilliseconds && newEventStartDTInMilliseconds < eventEndDTInMilliseconds) 
                && (eventStartDTInMilliseconds < newEventEndDTInMilliseconds && newEventEndDTInMilliseconds <= eventEndDTInMilliseconds)
            ) {
                ERROR = 'Cannot overlap event: existingStartDT newStartDT newEndDT existingEndDT';
            }
        }

        return ERROR;
    }
}