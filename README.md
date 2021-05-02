[![dependencies status](https://david-dm.org/takahitomiyamoto/event-based-apex-logger.svg)](https://david-dm.org/takahitomiyamoto/event-based-apex-logger)
[![devDependency status](https://david-dm.org/takahitomiyamoto/event-based-apex-logger/dev-status.svg)](https://david-dm.org/takahitomiyamoto/event-based-apex-logger#info=devDependencies)
[![Code Climate](https://codeclimate.com/github/takahitomiyamoto/event-based-apex-logger.svg)](https://codeclimate.com/github/takahitomiyamoto/event-based-apex-logger)
[![codecov](https://codecov.io/gh/takahitomiyamoto/event-based-apex-logger/branch/master/graph/badge.svg)](https://codecov.io/gh/takahitomiyamoto/event-based-apex-logger)

![GitHub issues](https://img.shields.io/github/issues/takahitomiyamoto/event-based-apex-logger)
![GitHub forks](https://img.shields.io/github/forks/takahitomiyamoto/event-based-apex-logger)
![GitHub stars](https://img.shields.io/github/stars/takahitomiyamoto/event-based-apex-logger)
![GitHub license](https://img.shields.io/github/license/takahitomiyamoto/event-based-apex-logger?color=blue)

<a href="https://twitter.com/intent/tweet?text=Happy Coding!!&url=https%3A%2F%2Fgithub.com%2Ftakahitomiyamoto%2Fevent-based-apex-logger"><img alt="Twitter" src="https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Ftakahitomiyamoto%2Fevent-based-apex-logger"></a>

# Event-based Apex Logger

This is a framework that automates our Apex logging powered by Platform Event.

Apex debug logs will be inserted to a custom object, such as `EAL_Logger__c`.
Use Platform Events only if the debug log contains the `ERROR` LoggingLevel.

## Remarks

Platform Event has some allocations, especially "Event Publishing: maximum number of event notifications published per hour" is one of the most inescapable allocations.
So we need to reduce its frequency as much as possible.

> [Platform Event Allocations](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_event_limits.htm)

## How to use

### 1. install the framework on your org

```sh
sfdx force:package:install -p event-based-apex-logger@1.0.3.0 -s AllUsers -u [targetusername]
sfdx force:package:install:report -i 0HfXXXXXXXXXXXXXXX -u [targetusername]
sfdx force:org:open -p lightning/setup/ImportedPackage/home -u [targetusername]
```

### 2. assign the permission set to one or more users of your org

```sh
sfdx force:user:permset:assign -n EAL_Logger_User -u [targetusername]
```

### 3. configure the custom metadata type : `EAL_LoggerConfig`

```sh
sfdx force:org:open -p lightning/setup/CustomMetadata/home -u [targetusername]
```

![logger-config](https://raw.githubusercontent.com/takahitomiyamoto/event-based-apex-logger/master/public/images/logger-config.png)

### 4. execute any apex code and see the custom tab : `EAL_Loggers`

```sh
sfdx force:org:open -u demo -p lightning/o/EAL_Logger__c/list -u [targetusername]
```

#### Sample Code

```java
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
```

![sample-code](https://raw.githubusercontent.com/takahitomiyamoto/event-based-apex-logger/master/public/images/sample-code.png)

## Acknowledgment

- [Advanced Logging with Platform Events](https://github.com/afawcett/eventlogging)
- [Apex Unified Logging](https://github.com/rsoesemann/apex-unified-logging)

---

## Appendix: How to create a package

### 1. create a package

```sh
sfdx force:package:create -d "This is a framework that automates our Apex logging powered by Platform Event." -e -n "event-based-apex-logger" -r force-app-eal -t Unlocked -v DevHub-EAL
```

### 2. create a package version

```sh
sfdx force:package:version:create -a "Summer '20" -b "master" -c -e "Summer '20 (API version 49.0)" -f config/project-scratch-def.json -n 1.0.0.0 -p 0HoXXXXXXXXXXXXXXX -t v49.0 -v DevHub-EAL -x --postinstallurl "https://github.com/takahitomiyamoto/event-based-apex-logger" --releasenotesurl "https://github.com/takahitomiyamoto/event-based-apex-logger/releases"
```

### 3. retrieve details about a package version creation request

```sh
sfdx force:package:version:create:report -i 08cXXXXXXXXXXXXXXX -v DevHub-EAL
```

### 4. list package version creation requests

```sh
sfdx force:package:version:create:list -s Success -v DevHub-EAL
```

### 5. promote a package version to released

```sh
sfdx force:package:version:promote -p 04tXXXXXXXXXXXXXXX -v DevHub-EAL
```

### 6. retrieve details about a package version in the Dev Hub org

```sh
sfdx force:package:version:report -p 04tXXXXXXXXXXXXXXX -v DevHub-EAL --verbose
```

### 7. list all packages in the Dev Hub org

```sh
sfdx force:package:list -v DevHub-EAL --verbose
```

### 8. list all package versions in the Dev Hub org

```sh
sfdx force:package:version:list -p event-based-apex-logger -v DevHub-EAL --verbose
```

## Appendix: How to update a package

### 1. create a package version

```sh
sfdx force:package:version:create -a "Winter '21" -b "master" -c -e "Winter '21 (API version 50.0)" -f config/project-scratch-def.json -n 1.0.3.0 -p 0HoXXXXXXXXXXXXXXX -t v50.0 -v DevHub-EAL -x --postinstallurl "https://github.com/takahitomiyamoto/event-based-apex-logger" --releasenotesurl "https://github.com/takahitomiyamoto/event-based-apex-logger/releases"
```

### 2. retrieve details about a package version creation request

```sh
sfdx force:package:version:create:report -i 08cXXXXXXXXXXXXXXX -v DevHub-EAL
```

### 3. update a package version

```sh
sfdx force:package:version:update -a "Winter '21" -b "master" -e "Winter '21 (API version 50.0)" -p 04tXXXXXXXXXXXXXXX -t v50.0 -v DevHub-EAL
```

### 4. promote a package version to released

```sh
sfdx force:package:version:promote -p 04tXXXXXXXXXXXXXXX -v DevHub-EAL
```

### 5. list all package versions in the Dev Hub org

```sh
sfdx force:package:version:list -p event-based-apex-logger -v DevHub-EAL --verbose
```
