all:
	cd L28.1 ; make
	cd L29.1 ; make
	cd RA-POC2 ; make
	cd RA-Nuxeo ; make

clean:
	cd L28.1 ; make clean
	cd L29.1 ; make clean
	cd RA-POC2 ; make clean
	cd RA-Nuxeo ; make clean
	
tidy:
	cd L28.1 ; make tidy
	cd L29.1 ; make tidy
	cd RA-POC2 ; make tidy
	cd RA-Nuxeo ; make tidy

