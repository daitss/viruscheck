Viruscheck Service
==========================

Viruscheck service is a stand-alone Sinatra applicatioa. It:

* accepts a POST request containing data, 
* Runs a virus scan on that data,
* Returns a PREMIS XML document describing the result of the scan.
 
Requirements
------------
* ruby (tested on 1.8.6 and 1.8.7)
* ruby-devel, rubygems, gcc and g++
* ClamAV (Clamd optional)
* libxml2-devel

Quick Start
----------
* Clone this git repository
* Run bundle install to download and build gem dependencies
* Configure service and environment (see the [DAITSS installation manual](www.fcla.edu/daitss-test/installmanual.pdf) for more detail) 

License
-------
GPL 3.0

