/**
 * @name EAL_LoggerEventTriggerService.cls
 * @description service for LoggerEventTrigger
 */
public without sharing class EAL_LoggerEventTriggerService {
  /**
   * @description fetch all debugLogs
   */
  public static void fetchDebugLogs() {
    List<EAL_LoggerEvent__e> events = (List<EAL_LoggerEvent__e>) Trigger.new;
    for (EAL_LoggerEvent__e event : events) {
      EAL_Logger logger = (EAL_Logger) JSON.deserialize(
        event.Logger__c,
        EAL_Logger.class
      );
      logger.fetch();
    }
  }
}
