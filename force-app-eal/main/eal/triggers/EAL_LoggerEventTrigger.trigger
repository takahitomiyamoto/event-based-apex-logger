/**
 * @name EAL_LoggerEventTrigger.trigger
 * @description trigger for EAL_LoggerEvent__e
 */
trigger EAL_LoggerEventTrigger on EAL_LoggerEvent__e(after insert) {
  EAL_LoggerEventTriggerService.fetchDebugLogs();
}
