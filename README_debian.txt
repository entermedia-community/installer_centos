Installation
1. Before you run the installation script, you must make sure apt sources list has access to libfaac. Perform the following tasks:

# Edit your repository sources list (vi shown here, use your preferred editor):
sudo vi /etc/apt/sources.list

# At the end of the file, add the following line:
deb http://www.deb-multimedia.org/ wheezy main non-free

# Save and exit the text editor and attempt to update apt (this may fail):

sudo apt-get update

# If there is an error, at the end of the output there should be a public key. Replace ${YOUR_KEY} below with this key. Enter the following commands to authenticate with your public key:

sudo gpg --keyserver pgpkeys.mit.edu --recv-key ${YOUR_KEY}
sudo gpg --armor --export ${YOUR_KEY} | sudo apt-key add -
sudo apt-get update

# Now you are ready to run the installer script (apt-get.sh)
