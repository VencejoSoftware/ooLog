[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooLog.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooLog)

# ooLog - Object pascal logger library
Library to use a logger based in dynamic template definitions

### Text file log example
```pascal
var
  TemplateFile, InfoTemplate: ITemplateLog;
  Log: ILog;
  LogActor: ILogActor;
begin
  TemplateFile := TTemplateLog.New('{AppPath}demo_{Month}{Year}.log', TInsensitiveTextMatch.New);
  InfoTemplate := TTemplateLog.New('{IP}:{PC}-{User}-{App}[{LogLevel}]>>{DateTime} {TEXT}', TInsensitiveTextMatch.New);
  Log := TTextFileLog.New(TemplateFile, InfoTemplate);
  LogActor := TLogActor.Create(Log);
  LogActor.LogDebug('Something');
  LogActor.LogErrorText('Fail!');
end;
```

### Documentation
If not exists folder "code-documentation" then run the batch "build_doc". The main entry is ./doc/index.html

### Demo
Before all, run the batch "build_demo" to build proyect. Then go to the folder "demo\build\release\" and run the executable.

## Dependencies
* [ooGeneric](https://github.com/VencejoSoftware/ooGeneric.git) - Generic object oriented list
* [ooText](https://github.com/VencejoSoftware/ooText.git) - Object pascal string library
* [ooOS](https://github.com/VencejoSoftware/ooOS.git) - Object pascal operation system library
* [ooParser](https://github.com/VencejoSoftware/ooParser.git) - Object pascal base parser
* [ooTemplateParser](https://github.com/VencejoSoftware/ooTemplateParser.git) - Object pascal template parser library
* [ooScapeTranslate](https://github.com/VencejoSoftware/ooScapeTranslate.git) - Object pascal scape translate
* [ooConsole](https://github.com/VencejoSoftware/ooConsole.git) - Object pascal console handler

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*