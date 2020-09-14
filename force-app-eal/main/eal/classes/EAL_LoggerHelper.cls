/**
 * @name EAL_LoggerHelper.cls
 * @description utilities for EAL_Logger
 */
public without sharing class EAL_LoggerHelper {
  // Constants
  private static final String FIELD_RECORD_TYPE_ID = EAL_LoggerConstants.FIELD_RECORD_TYPE_ID;
  private static final String LOGGER_DEFAULT = EAL_LoggerConstants.LOGGER_DEFAULT;
  private static final String SYMBOL_CLS = EAL_LoggerConstants.SYMBOL_CLS;
  private static final String SYMBOL_DIVIDER = EAL_LoggerConstants.SYMBOL_DIVIDER;
  private static final String SYMBOL_NEWLINE = EAL_LoggerConstants.SYMBOL_NEWLINE;

  // Class Variables
  private static EAL_LoggerHelper singleton = new EAL_LoggerHelper();

  // Instance Variables
  private String timestampNow;
  private EAL_LoggerConfig__mdt defaultLoggerConfig;

  /**
   * @description private constructor with no parameter
   */
  private EAL_LoggerHelper() {
    this.setDefaultLoggerConfig();
  }

  /**
   * @description get EAL_LoggerConfig__mdt
   * @param developerName
   * @return EAL_LoggerConfig__mdt
   */
  private EAL_LoggerConfig__mdt queryLoggerConfig(String developerName) {
    return [
      SELECT
        Archive__c,
        DateFormat__c,
        LoggerObject__r.QualifiedApiName,
        LoggerObjectLoggingLevel__r.QualifiedApiName,
        LoggerObjectLogMessage__r.QualifiedApiName,
        LoggerObjectName__r.QualifiedApiName,
        LoggerObjectRecordType__c,
        LoggerObjectTimestamp__r.QualifiedApiName,
        LoggingLevel__c,
        MaxLength__c,
        Timezone__c
      FROM EAL_LoggerConfig__mdt
      WHERE DeveloperName = :developerName
      WITH SECURITY_ENFORCED
    ];
  }

  /**
   * @description set TimestampNow
   */
  private void setTimestampNow() {
    this.timestampNow = String.valueof(
      Datetime.now()
        .format(this.getDefaultDateFormat(), this.getDefaultTimezone())
    );
  }

  /**
   * @description get TimestampNow
   * @return timestampNow
   */
  private String getTimestampNow() {
    return this.timestampNow;
  }

  /**
   * @description set default EAL_LoggerConfig__mdt
   */
  private void setDefaultLoggerConfig() {
    this.defaultLoggerConfig = this.queryLoggerConfig(LOGGER_DEFAULT);
  }

  /**
   * @description get default EAL_LoggerConfig__mdt
   * @return defaultLoggerConfig
   */
  private EAL_LoggerConfig__mdt getDefaultLoggerConfig() {
    return this.defaultLoggerConfig;
  }

  /**
   * @description get default LoggingLevel
   * @return defaultLoggerConfig.LoggingLevel__c
   */
  private String getDefaultLoggingLevelValue() {
    EAL_LoggerConfig__mdt defaultLoggerConfig = this.getDefaultLoggerConfig();
    return defaultLoggerConfig.LoggingLevel__c;
  }

  /**
   * @description get default maxLength
   * @return this.defaultLoggerConfig.MaxLength__c
   */
  @TestVisible
  private Integer getDefaultMaxLength() {
    return Integer.valueOf(this.defaultLoggerConfig.MaxLength__c);
  }

  /**
   * @description get default timezone
   * @return this.defaultLoggerConfig.Timezone__c
   */
  @TestVisible
  private String getDefaultTimezone() {
    EAL_LoggerConfig__mdt defaultLoggerConfig = this.getDefaultLoggerConfig();
    return defaultLoggerConfig.Timezone__c;
  }

  /**
   * @description get default date format
   * @return this.defaultLoggerConfig.DateFormat__c
   */
  @TestVisible
  private String getDefaultDateFormat() {
    EAL_LoggerConfig__mdt defaultLoggerConfig = this.getDefaultLoggerConfig();
    return defaultLoggerConfig.DateFormat__c;
  }

  /**
   * @description get LoggingLevel
   * @param value
   * @return LoggingLevel
   */
  @TestVisible
  private LoggingLevel getLoggingLevel(String value) {
    switch on value {
      when 'NONE' {
        return LoggingLevel.NONE;
      }
      when 'ERROR' {
        return LoggingLevel.ERROR;
      }
      when 'WARN' {
        return LoggingLevel.WARN;
      }
      when 'INFO' {
        return LoggingLevel.INFO;
      }
      when 'DEBUG' {
        return LoggingLevel.DEBUG;
      }
      when 'FINE' {
        return LoggingLevel.FINE;
      }
      when 'FINER' {
        return LoggingLevel.FINER;
      }
      when 'FINEST' {
        return LoggingLevel.FINEST;
      }
      when else {
        return LoggingLevel.DEBUG;
      }
    }
  }

  /**
   * @description get the instance
   * @return singleton
   */
  public static EAL_LoggerHelper getInstance() {
    return singleton;
  }

  /**
   * @description get default LoggingLevel
   * @return LoggingLevel
   */
  public LoggingLevel getDefaultLoggingLevel() {
    String value = this.getDefaultLoggingLevelValue();
    return this.getLoggingLevel(value);
  }

  /**
   * @description whether Logging is enabled or not
   * @param defaultLevel
   * @return Boolean
   */
  public Boolean notLogging(LoggingLevel defaultLevel) {
    return LoggingLevel.NONE.equals(defaultLevel);
  }

  /**
   * @description whether this logginglevel is higher than default or not
   * @param level
   * @param defaultLevel
   * @return level.ordinal() >= defaultLevel.ordinal()
   */
  public Boolean isHigherLevel(LoggingLevel level, LoggingLevel defaultLevel) {
    return level.ordinal() >= defaultLevel.ordinal();
  }

  /**
   * @description create debugLog message
   * @param methodName
   * @param message
   * @return methodName + SYMBOL_DIVIDER + message
   */
  public String createLogMessage(String methodName, Object message) {
    return methodName + SYMBOL_DIVIDER + message;
  }

  /**
   * @description create debugLog
   * @param level
   * @param className
   * @param logMessage
   * @return String
   */
  public String createDebugLog(
    LoggingLevel level,
    String className,
    Object logMessage
  ) {
    return className +
      SYMBOL_CLS +
      SYMBOL_DIVIDER +
      String.valueOf(level) +
      SYMBOL_DIVIDER +
      logMessage;
  }

  /**
   * @description whether Logger Object is archivable or not
   * @return defaultLoggerConfig.Archive__c
   */
  public Boolean archivable() {
    EAL_LoggerConfig__mdt defaultLoggerConfig = this.getDefaultLoggerConfig();
    return defaultLoggerConfig.Archive__c;
  }

  /**
   * @description archive Logger Object
   * @param logMessage
   */
  public void archiveLoggerObject(String logMessage) {
    this.setTimestampNow();

    EAL_LoggerConfig__mdt defaultLoggerConfig = this.getDefaultLoggerConfig();
    final String OBJECT_LOGGER = defaultLoggerConfig.LoggerObject__r.QualifiedApiName;
    final String FIELD_TIMESTAMP = defaultLoggerConfig.LoggerObjectTimestamp__r.QualifiedApiName;
    final String FIELD_LOGGING_LEVEL = defaultLoggerConfig.LoggerObjectLoggingLevel__r.QualifiedApiName;
    final String FIELD_LOG_MESSAGE = defaultLoggerConfig.LoggerObjectLogMessage__r.QualifiedApiName;
    SObject loggerObject = EAL_CommonUtils.createObject(OBJECT_LOGGER);

    // Logger RecordTypeId
    Id defaultLoggerRecordTypeId = EAL_CommonUtils.getRecordTypeId(
      OBJECT_LOGGER,
      defaultLoggerConfig.LoggerObjectRecordType__c
    );
    loggerObject.put(FIELD_RECORD_TYPE_ID, defaultLoggerRecordTypeId);

    // Logger Timestamp
    loggerObject.put(FIELD_TIMESTAMP, this.getTimestampNow());

    // Logging Level
    loggerObject.put(FIELD_LOGGING_LEVEL, defaultLoggerConfig.LoggingLevel__c);

    // Log Message
    loggerObject.put(FIELD_LOG_MESSAGE, logMessage);

    Database.SaveResult result = Database.insert(loggerObject, false);
    EAL_CommonError.handleError(result);
  }

  /**
   * @description create debug log message
   * @param debugLogs
   * @return logMessage
   */
  public String createDebugLogMessage(List<String> debugLogs) {
    String logMessage = String.join(debugLogs, SYMBOL_NEWLINE);
    Integer maxLength = this.getDefaultMaxLength();
    Boolean isLong = (maxLength < logMessage.length());
    if (isLong) {
      logMessage = logMessage.abbreviate(maxLength);
    }

    return logMessage;
  }

  /**
   * @description create EAL_LoggerEvent__e
   * @param logger
   * @return events
   */
  public List<EAL_LoggerEvent__e> createLoggerEvent(EAL_Logger logger) {
    EAL_LoggerEvent__e event = new EAL_LoggerEvent__e();
    event.Logger__c = JSON.serialize(logger);
    List<EAL_LoggerEvent__e> events = new List<EAL_LoggerEvent__e>();
    events.add(event);

    return events;
  }
}
