/**
 * @name EAL_LoggerEventTriggerServiceTest.cls
 * @description test class for EAL_LoggerEventTriggerService
 */
@isTest(SeeAllData=false)
private class EAL_LoggerEventTriggerServiceTest {
  @isTest
  static void fetchDebugLogs() {
    EAL_Logger logger = EAL_Logger.getInstance();
    logger.store(LoggingLevel.DEBUG, 'test');

    EAL_LoggerHelper helper = EAL_LoggerHelper.getInstance();
    List<EAL_LoggerEvent__e> events = helper.createLoggerEvent(logger);

    Test.startTest();
    List<Database.SaveResult> results = EventBus.publish(events);
    Test.getEventBus().deliver();
    Test.stopTest();

    for (Database.SaveResult result : results) {
      System.assertEquals(true, result.isSuccess(), 'fetchDebugLogs');
    }
  }
}
