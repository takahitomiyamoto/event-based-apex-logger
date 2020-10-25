/**
 * @name EAL_CommonErrorTest.cls
 * @description test class for EAL_CommonError
 */
@isTest(SeeAllData=false)
private class EAL_CommonErrorTest {
  @isTest
  static void handleErrorNull() {
    Database.SaveResult result = null;

    Test.startTest();
    EAL_CommonError.handleError(result);
    Test.stopTest();

    System.assertEquals(null, result, 'handleErrorNull');
  }

  @isTest
  static void handleErrorsNull() {
    List<Database.SaveResult> result = null;

    Test.startTest();
    EAL_CommonError.handleErrors(result);
    Test.stopTest();

    System.assertEquals(null, result, 'handleErrorsNull');
  }

  @isTest
  static void hasStackTraceEmpty() {
    Test.startTest();
    String stackTrace = '()\n';
    Boolean result = EAL_CommonError.hasStackTrace(stackTrace);
    Test.stopTest();

    System.assertEquals(false, result, 'hasStackTraceEmpty');
  }

  @isTest
  static void createErrorMessageException() {
    Test.startTest();
    List<Boolean> exceptions = new List<Boolean>();
    try {
      Account account = new Account();
      update account;
    } catch (Exception e) {
      exceptions.add(true);
      String message = EAL_CommonError.createErrorMessage(e);
      System.assertNotEquals('', message, 'createErrorMessageException');
    }
    Test.stopTest();

    for (Boolean b : exceptions) {
      System.assertEquals(true, b, 'createErrorMessageException');
    }
  }

  @isTest
  static void createErrorMessageCustomException() {
    Test.startTest();
    List<Boolean> exceptions = new List<Boolean>();
    try {
      throw new EAL_CommonError.CustomException();
    } catch (Exception e) {
      exceptions.add(true);
      String message = EAL_CommonError.createErrorMessage(e);
      System.assertNotEquals('', message, 'createErrorMessageCustomException');
    }
    Test.stopTest();

    for (Boolean b : exceptions) {
      System.assertEquals(true, b, 'createErrorMessageCustomException');
    }
  }

  @isTest
  static void createErrorMessageDatabaseError() {
    Test.startTest();
    Account a = new Account();
    String msg = 'New error method in SObject';
    a.addError('Name', msg);
    List<Database.Error> errors = a.getErrors();
    Database.Error error = errors.get(0);
    String message = EAL_CommonError.createErrorMessage(error);
    Test.stopTest();

    System.assertEquals(1, errors.size(), 'createErrorMessageDatabaseError');
    System.assertNotEquals('', message, 'createErrorMessageDatabaseError');
  }

  @isTest
  static void handleErrors() {
    Test.startTest();
    List<Account> accounts = new List<Account>();
    accounts.add(new Account());
    accounts.add(new Account());
    List<Database.SaveResult> results = Database.insert(accounts, false);
    EAL_CommonError.handleErrors(results);
    Test.stopTest();

    System.assertEquals(2, results.size(), 'handleErrors');
  }
}
