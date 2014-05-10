set ZIP=c:\apps\pkzip25\pkzip25
set ARCHIVE=resume.zip

%ZIP% -add=update -recurse -path=full -exclude="*~ .git" %ARCHIVE% *
c:\apps\scripts\util\email.bat %ARCHIVE%
