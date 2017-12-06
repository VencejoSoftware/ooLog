@echo off

if not exist %delphiooLib%\ooBatch\ (
  @echo "Clonning ooBatch..."
  git clone https://github.com/VencejoSoftware/ooBatch.git %delphiooLib%\ooBatch\
  call %delphiooLib%\ooBatch\code\get_dependencies.bat
)

if not exist %delphiooLib%\ooScapeTranslate\ (
  @echo "Clonning ooScapeTranslate..."
  git clone https://github.com/VencejoSoftware/ooScapeTranslate.git %delphiooLib%\ooScapeTranslate\
  call %delphiooLib%\ooScapeTranslate\batch\get_dependencies.bat
)

if not exist %delphiooLib%\ooTemplateParser\ (
  @echo "Clonning ooTemplateParser..."
  git clone https://github.com/VencejoSoftware/ooTemplateParser.git %delphiooLib%\ooTemplateParser\
  call %delphiooLib%\ooTemplateParser\batch\get_dependencies.bat
)

if not exist %delphiooLib%\ooOS\ (
  @echo "Clonning ooOS..."
  git clone https://github.com/VencejoSoftware/ooOS.git %delphiooLib%\ooOS\
  call %delphiooLib%\ooOS\batch\get_dependencies.bat
)