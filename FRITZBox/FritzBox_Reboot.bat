@echo off
:: COMMENT
:: © 2012 https://github.com/Michel-IT. All rights reserved.
:: You can use this file and disclose it. 
:: Please do not remove this comment. 
:: Out of respect for intellectual property.

SET IP=192.168.178.1
SET FRITZUSER=fritz1234
SET FRITZPW=password1234
SET location=/upnp/control/deviceconfig
SET uri=urn:dslforum-org:service:DeviceConfig:1
SET action=Reboot
curl -k -m 5 --anyauth -u %FRITZUSER%:%FRITZPW% "http://%IP%:49000%location%" -H "Content-Type: text/xml; charset=\"utf-8\"" -H "SoapAction:%uri%#%action%" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:%action% xmlns:u='%uri%'></u:%action%></s:Body></s:Envelope>" 
