

### commands
`$ pip freeze` -   display the all installed packages and installed packages and versions  
 
    pip freeze > requirements.txt
    pip install -r requirements.txt

 You must give at least one requirement to install (see "pip help install")
 
***************************************************************************
##### Django
`$ python -m django --version` - version of django installed
cd into a directory where you’d like to store your code, then run the following command: `$ django-admin startproject mysite` 
***************************************************************************
##### virtualenv 
######  Samples
 (myproject) @ ~/Documents/code/coding_python/myproject
 `virtualenv myproject`
 `virtualenv -p /usr/local/bin/python3 myproject` 
 `export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3`

@ ~/Documents/code/coding_python/Flask_Task
 `python3 -m venv venv` . #creates folder 'venv' & virtual environment
  `source venv/bin/activate`
 *(venv) @ ~/Documents/code/coding_python/Flask_Task # venv activated*

Reference: [virtualenv](http://docs.python-guide.org/en/latest/dev/virtualenvs/#virtualenvironments-ref)
 
***************************************************************************


