import os
path = os.getcwd()
print path
for root, dirs, files in os.walk(path):
    for file in files:
        if file.endswith('.py') and "helper" not in file:
            os.system(('python %s') % (file))
            print file

