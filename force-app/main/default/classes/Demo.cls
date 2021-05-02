public with sharing class Demo {
  private final EAL_Logger logger = EAL_Logger.getInstance();

  private void setMethodName(String methodName) {
    logger.setClassName(Demo.class.getName());
    logger.setMethodName(methodName);
  }

  public void runDemo() {
    this.setMethodName('demo');
    try {
      Account account = new Account();
      insert account;
    } catch (Exception e) {
      logger.store(LoggingLevel.ERROR, EAL_CommonError.createErrorMessage(e));
    } finally {
      logger.publish();
      logger.clear();
    }
  }
}
