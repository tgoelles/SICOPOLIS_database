# SICOPOLIS_database

A tool to generate a database of experiments with the open source ice sheet model SICOPOLIS (http://www.sicopolis.net).

Generates a semicolon separated CSV file from the header file. 


# Installation

Please make sure that you have md5 and mktemp installed.

Copy the scripts to your script folder, for example $HOME/bin.

Here is a detailed manual:

1.) create a folder for the scripts 


```
mkdir $HOME/bin
```

2.) copy datagen.sh and nocomment.sh to the folder  $HOME/bin


```
cp datagen.sh $HOME/bin
cp nocomment.sh $HOME/bin
```

3.) 

Finally, add the following line to your .bash_profile or .bashrc 


```
export PATH="$HOME/bin:$PATH"
```

### Optional

If you are using a mac you can generate a Service with Automator:

![](automator.png)

Then you can right click on a folder with SICOPOLIS output and choose Services => your service.
This will generate a csv file from sico_specs.h on the desktop.

# Usage

Go to a folder with SICOPOLIS output and type the command in the terminal:


```
header2csv.sh 
```

This generates a CSV file on the Desktop from the header "sico_specs.h". 

header2csv can also be used for other headers:
  
```
header2csv.sh sico_specs_v5_tibet_test.h
```

The default location for the csv file is the Desktop. Optionally you can give the location as the second argument. For example:

```
header2csv.sh sico_specs_v5_tibet_test.h ~/
```

