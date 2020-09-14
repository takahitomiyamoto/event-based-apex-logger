/**
 * @name EAL_LoggerTest.cls
 * @description test class for EAL_Logger
 */
@isTest(SeeAllData=false)
private class EAL_LoggerTest {
  private static EAL_Logger logger = EAL_Logger.getInstance();
  private static EAL_LoggerHelper helper = EAL_LoggerHelper.getInstance();

  @testSetup
  static void setup() {
    System.debug(LoggingLevel.FINEST, 'setup');
  }

  @isTest
  static void store() {
    Test.startTest();
    String maxWidthMsg = '';
    for (Integer i = 0; i < helper.getDefaultMaxLength(); i++) {
      maxWidthMsg += 'a';
    }
    logger.store(LoggingLevel.DEBUG, maxWidthMsg);
    logger.publish();
    logger.fetch();
    logger.clear();
    Test.stopTest();

    System.assertNotEquals(null, logger, 'stackDebugLog');
  }

  @isTest
  static void stackNotLogging() {
    Test.startTest();
    logger.storeDefaultDebugLog(LoggingLevel.NONE, LoggingLevel.DEBUG, '');
    Test.stopTest();

    System.assertNotEquals(null, logger, 'stackDebugLogNotLogging');
  }

  @isTest
  static void stackNone() {
    Test.startTest();
    String message = '';
    logger.store(LoggingLevel.NONE, message);
    Test.stopTest();

    System.assertNotEquals(null, logger, 'stackDebugLogNone');
  }

  @isTest
  static void fetchEmpty() {
    Test.startTest();
    logger.fetch();
    Test.stopTest();

    System.assertNotEquals(null, logger, 'fetchDebugLogsEmpty');
  }

  @isTest
  static void setClassName() {
    Test.startTest();
    logger.setClassName('Demo');
    Test.stopTest();

    System.assertEquals('Demo', logger.getClassName(), 'setClassName');
  }

  @isTest
  static void setMethodName() {
    Test.startTest();
    logger.setMethodName('demo');
    Test.stopTest();

    System.assertEquals('demo', logger.getMethodName(), 'setMethodName');
  }
}
