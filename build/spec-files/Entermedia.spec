#
# Entermedia Spec file...
#
Summary:	Entermedia Software Digital Asset Management
Name: 		entermedia
Version: 	1.0
Release: 	1
License: 	GNU GPL
URL:		https://github.com/entermedia-community
Vendor: 	EnterMedia Software, Inc.

%package base
Summary: 	Dependencies Required for transcoding in Entermedia
Requires: 	tomcat >= 8.0
Requires: 	ImageMagick
Requires: 	libav

%description base
EnterMedia is an Open Source Media Database that empowers you to take control of managing every aspect of digital assets by providing developers with powerful API’s to build custom applications, and providing users with an intuitive front end that can be rearranged and personalized for specific needs. Our flexible and proven platform allows users to centralize, secure, and share content, manage workflow, and track details and changes throughout the system.

%prep
# Check if the WAR file has been created
if curl --output /dev/null --silent --head --fail "http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war"; then
  echo "Found WAR File."
else
  echo "Failed. URL does not exist"
  exit 1
fi

# Download Tomcat and Entermedia
mkdir -p /opt/entermedia/webapp
cd /opt/entermedia
wget https://github.com/entermedia-community/tomcat8/archive/master.zip -O tomcat.zip
cd ./webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O ROOT.war

#Create Entermedia User
if id -u entermedia >/dev/null 2>&1; then
        echo "entermedia user already exists"
else
        adduser entermedia
fi

usermod -a -G vboxsf entermedia

%install
#Install Tomcat
cd /opt/entermedia
unzip tomcat.zip
mv tomcat8-master tomcat
mkdir -p ./tomcat/logs
rm tomcat.zip
mv ./tomcat/tomcat /etc/init.d/
chkconfig --add tomcat
chkconfig --level 3 tomcat on
chkconfig --level 5 tomcat on

#Install Entermedia
cd ./webapp
unzip ROOT.war
rm ROOT.war

%files
# Set file permissions and ownership
#chown -R entermedia:entermedia /opt/entermedia
#chmod -R u+s,g+s /opt/entermedia 

%pre
# Validation step

%post
echo "Installation complete."