@echo off

SET IP=192.168.178.1
::SET FRITZUSER=fritz1234 
::SET FRITZPW=password1234
SET location=/igdupnp/control/WANIPConn1
SET uri=urn:schemas-upnp-org:service:WANIPConnection:1
SET action=ForceTermination
curl -s "http://%IP%:49000%location%" -H "Content-Type: text/xml; charset=\"utf-8\"" -H "SoapAction:%uri%#%action%" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:%action% xmlns:u='%uri%'></u:%action%></s:Body></s:Envelope>"
