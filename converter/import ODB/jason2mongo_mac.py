import os
path = os.getcwd()

fileName = "ecommerce.json"
jsonFile = "%s\%s" % (path,fileName)
with open(jsonFile) as f:
    lines = f.readlines()
lines = filter(None,[x.strip() for x in lines])
bash = []
for index,string in enumerate(lines):
    if "ecommerce." in string:
        table=string.split(".", 1)[1]
        cmd1 ="mongoimport --db ecommerce --collection %s --drop --file %s\%s.json --jsonArray" %(table,path,table)
        # cmd2 = "del %s.json" % (table) # for windows
        cmd2 = "rm %s.json" % (table) # for mac or linux
        bash.append(cmd1)
        bash.append(cmd2)
        for i in range(index+1, index + 2):
            content = lines[i]
        newFileName = "%s\%s.json" % (path,table)
        newFile = open(newFileName,'w') 
        newFile.write(content)
        print "Table %s is done" % table
newFile.close()

newFileName = "%s\import.sh" % (path)
newFile = open(newFileName,'w') 
for cmd in bash:
    newFile.write(cmd + '\n')
newFile.write("rm import.sh \n")
newFile.close()

from subprocess import Popen
Popen(newFileName)